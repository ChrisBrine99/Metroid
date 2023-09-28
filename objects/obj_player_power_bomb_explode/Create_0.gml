#region Macro initialization

// 
#macro	POWER_BOMB_DAMAGE			50
#macro	POWER_BOMB_STUN_DURATION	20.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Use the inherited hitpoint variables as a timer that will result in the bomb exploding after said hitpoint
// value reaches or goes below 0. It will determine how long the power bomb explosion will occur, with one
// second of real time equalling 60 units in the code.
maxHitpoints	= 90.0;
hitpoints		= maxHitpoints;

// 
play_sound_effect(snd_powerbombexplode, 0, false, true, 0.8);

#endregion

#region Unique varible initializations

// Variables for the surface that the power bomb's explosion is rendered to. The effect darkens the application surface
// and creates a bright yellow oval that rapidly expands for the duration of said explosion.
pBombSurf	= -1;
surfWidth	= display_get_gui_width();
surfHeight	= display_get_gui_height();

// The variables that represent what the power bomb can hit (Radius), how fast its radius expands, and the
// current opacity value of the explosion, which will fade in and out during the beginning and the end of
// the explosion, respectively.
pBombAlpha		 = 0.0;
pBombRadius		 = 0.0;
pBombRadiusSpeed = 3.0;

#endregion

#region State function initializations

/// @description The power bomb's main and only state. It will endlessly shake the camera and expands its
/// radius of destruction; only being stopped by the timer for the bomb's life (Using "hitpoints" variable
/// from its inherited variables) reaching zero. After that, the explosion will end and the instance will
/// be deleted from the room.
state_default = function(){
	// Causes the camera to shake intensely for the duration of the power bomb explosion. Once the explosion
	// ceases, a 10 "frame" (About 1/6th of a second) shake will allow the shake to peeter out smoothly.
	camera_set_shake(8, 10);
	
	// Decrement the timer for the power bomb's life until it reaches zero. After this, the explosion will
	// be considered finished; no longer expanding in size and no longer colliding with destructible objects
	// and enemies. The alpha is decreased until it reaches zero to smoothly fade out the effect before the
	// instance is deleted.
	hitpoints -= DELTA_TIME;
	if (hitpoints <= 0.0){
		pBombAlpha -= DELTA_TIME * 0.1;
		if (pBombAlpha <= 0.0){
			object_set_next_state(NO_STATE);
			stateFlags |= ENTT_DESTROYED;
		}
		return;
	}
	
	// Increase the power bomb explosion's opacity until it reaches one; allowing a smooth appearance of
	// the explosion when it first begins.
	pBombAlpha += DELTA_TIME * 0.1;
	if (pBombAlpha >= 1.0) {pBombAlpha = 1.0;}
	
	// Constantly increase the radius of the power bomb for the duration of its explosion; with no limit
	// in its size aside from what the length of the explosion is.
	pBombRadius += pBombRadiusSpeed * DELTA_TIME;
	
	// Store characteristics about the Power Bomb--its position and radius--before collisions are processed
	// against destructibles, enemies, and doors using these stored variables.
	var _radius = pBombRadius;
	var _x		= x;
	var _y		= y;
	
	// Check collision against all destructible objects within the room; destroying any that are susceptible
	// to the power bomb's explosion. Any destructilbes that aren't weak to the power bomb will simply be
	// skipped over in this loop.
	with(par_destructible){
		// If the destructible is already destroyed OR its object index doesn't match what the power bomb
		// is able to destroy out of all possible destructible types, it will be skipped over for the 
		// distance check that occurs for valid objects.
		if (!ENTT_IS_ON_SCREEN || ENTT_IS_DESTROYED || (object_index != obj_destructible_all && 
				object_index != obj_destructible_collectible_ball && object_index != obj_destructible_power_bomb)) 
			continue;
		
		// Determine if the destructible is within current range of the explosion. If so, the destructible 
		// will be destroyed by the blast.
		if (distance_to_point(_x, _y) <= _radius) 
			destructible_destroy_self();
	}
	
	// Walk through all instances of Door objects within the room (They are inherit from "obj_general_door"
	// instead of a parent object using the "par_" prefix) to check if they have come into contact with the
	// current explosion's affected radius or not.
	var _isDestroyed = false;
	with(obj_general_door){
		// Skip over any door instance that is outside of the Camera's view, OR whose distance from the 
		// power bomb is greater than the current radius of the explosion itself.
		if (!ENTT_IS_ON_SCREEN || distance_to_point(_x, _y) > _radius) {continue;}
		
		switch(object_index){
			case obj_general_door:		_isDestroyed = true;						break;
			case obj_power_bomb_door:	_isDestroyed = true;						break;
			case obj_inactive_door:		_isDestroyed = inactive_door_collision();	break;
		}
		
		// If the local flag is set to true after the switch statement has been processed, the door will
		// be opened by the bomb's explosion. Otherwise, nothing will happen to the door.
		if (_isDestroyed){
			if (flagID != EVENT_FLAG_INVALID) 
				event_set_flag(flagID, true);
			animSpeed		= 1.0;
			_isDestroyed	= false;
		}
	}
	
	// Much like Door objects, each Enemy in the room will be stepped through to see if the power bomb explosion
	// has come into contact with it or not. If so (And other conditions have been passed), the enemy will be
	// damaged and stunned by the explosion.
	with(par_enemy){
		// Skip over Enemy instances that have already been hit, are already considered destroyed in their 
		// state flags, OR are outside of the current radius of the power bomb's explosion.
		if (ENTT_IS_HIT_STUNNED || ENTT_IS_DESTROYED || !(weaknessFlags & ENMY_POWBOMB_WEAK) || 
				distance_to_point(_x, _y) > _radius)
			continue;
		entity_apply_hitstun(POWER_BOMB_DAMAGE, POWER_BOMB_STUN_DURATION);
	}
}

#endregion