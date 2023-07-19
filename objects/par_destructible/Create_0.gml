#region Macro value initializations

// Bit flags that are unique to a destructible object. The first will toggle the destruction and rebuild
// effects for the block on and off, and the second will determine if the block is masked by a tile in the
// world instead of being shown to the player by default.
#macro	USE_EFFECTS				19
#macro	HIDDEN					20

// Condenses the check for the state of each bit flag that is unique to a destructible object into two macros.
#macro	CAN_USE_EFFECTS			(stateFlags & (1 << USE_EFFECTS))
#macro	IS_HIDDEN				(stateFlags & (1 << HIDDEN))

// Macro values storing the amount of time a given block will remain destroyed for; measured in 60 equalling
// one second of real-time due to how my delta timing implementation is determined.
#macro	RESPAWN_TIMER_INFINITE -255
#macro	RESPAWN_TIMER_GENERAL	600
#macro	RESPAWN_TIMER_BOMB		1200
#macro	RESPAWN_TIMER_WEIGHT	30
#macro	RESPAWN_TIMER_SATTACK	450

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Make the entity visible within the room and set its state bits up so it draws the sprite that is set for 
// any child destructible object. Also, set the sprite index so it doesn't trigger the drawing code for the
// object until "entity_set_sprite" is called. Otherwise, the game will crash trying to draw an invalid sprite.
stateFlags |= (1 << DRAW_SPRITE) | (1 << USE_EFFECTS);
sprite_index = NO_SPRITE;
visible = true;

#endregion

#region Unique variable initializations

// Stores the pointer value for a destruction or rebuilding effect that may exist for when a destructible
// transitions between its standard and "destroyed" states, respectively.
effectID = noone;

// This variable pair is used for any destructible blocks that are hidden within the game's world. They will
// store the required tile set and tile information to render that tile on top of them until they are no longer
// hidden.
tileset = -1;
tiledata = -1;

// The top value stores the block's unique time in "frames" (One frame is equal to 1/60th of a second of real 
// time) before the block will attempt to respawn itself after being destroyed. Setting this value to the macro 
// "RESPAWN_TIMER_INFINITE" will cause the block to destroy itself for the duration of the room's existence. 
// Finally, the bottom value simply tracks the time elapsed since the block was considered "destroyed".
timeToRespawn = 0;
respawnTimer = 0;

#endregion

#region Utility function initializations

/// @description The function that should be called whenever a valid projectile, entity, or explosion has triggered
/// a collision between itself and a destructible object that is affected by it. It will create an instance of
/// a struct that is used for animating the block's destruction while also temporarily disabling collision and
/// sprite rendering for the block in question.
destructible_destroy_self = function(){
	// Create the block destruction effect if the block in question has been toggled to do so.
	if (CAN_USE_EFFECTS){
		var _x = x;
		var _y = y;
		var _id = id;
		effectID = instance_create_struct(obj_destructible_effect);
		with(effectID){
			x =				_x;
			y =				_y;
			parentID =		_id;
			imageIndex =	0;
			animSpeed =		1;
		}
	}
	
	// Update the state flags for the block so that it is no longer visible or interactable (Collision) with
	// the player object. These states are reversed if the block can rebuild itself.
	stateFlags &= ~((1 << DRAW_SPRITE) | (1 << HIDDEN));
	stateFlags |= (1 << DESTROYED);
	mask_index = spr_empty_mask;
}

/// @description A function that is basically the reverse of the above function with a few added factors to
/// consider during the "rebuilding" phase. It automatically cleans up the effect struct's pointer data and
/// resets the block to its normal state if possible (The block will no longer be hidden until the player
/// leaves the room and comes back again).
destructible_rebuild_self = function(){
	// Remove the effect struct that plays the block destruction animation in reverse in order to have it
	// "rebuild" itself before instantly reappearing in the world.
	instance_destroy_struct(effectID);
	delete effectID;
	effectID = noone;
	
	// In order to properly rebuild, a collision check is done with the area occupied by the block and any
	// dynamic entities. If there is an entity within the space, the block will be unable to rebuild and will
	// instead destroy itself again for its required duration. It will repeat this until no collisions are
	// found in the block's space.
	mask_index = -1;	// Sets the collision mask to match the current sprite's collision data.
	if (place_meeting(x, y, par_dynamic_entity)){
		destructible_destroy_self();
		return;
	}
	stateFlags |= (1 << DRAW_SPRITE);
}

/// @description A function that can be placed into the step event in any child of this parent destructible;
/// enabling it to be destroyed by Samus's somersault jump if she has previously acquired the Screw Attack.
step_screw_attack_check = function(){
	// 
	event_inherited();
	if (IS_DESTROYED) {return;}

	// 
	var _x = x + 8;
	var _y = y + 8;
	with(PLAYER){
		if (!IS_JUMP_ATTACK) {return;}
	
		// 
		var _pY = y - (bbox_bottom - bbox_top);
		if (point_distance(0, _pY, 0, _y) <= 24 && point_distance(x, 0, _x, 0) <= 16){
			with(other){destructible_destroy_self();}
		}
	}
}

#endregion