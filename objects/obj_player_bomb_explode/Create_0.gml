#region Macro initialization

//
//	Macros for the damage output of the standard bomb explosion as well as its stun duration on enemies 
//	that have been hit by said explosion.
//

#macro	BOMB_DAMAGE				4
#macro	BOMB_STUN_DURATION		10.0

// 
//	
// 
#macro	BOMB_EXPLODE_VOLUME		0.7

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Unique variable initializations

// Stores a list of all destructible objects that have come into contact with the bomb explosion. It's looped
// through in the bomb explosion's main state to check if the destructible should be destroyed by it or not.
collisionList = ds_list_create();

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
__initialize = initialize;
/// @description Initializes the bomb object; setting its state, flipping the bit to enable its rendering,
/// and setting its sprite.
/// @param {Function}	state
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_player_bomb_explode, -1);
	object_add_light_component(x, y, 0, 0, 100, HEX_LIGHT_BLUE);
	play_sound_effect(snd_bombexplode, 0, false, true, SND_TYPE_GENERAL, BOMB_EXPLODE_VOLUME);
	stateFlags |= ENTT_DRAW_SELF;
}

#endregion

#region State function initialization

/// @description A simple state that performs two things when called. First, a check to see if its explosion
/// animation has ended so it can be flagged for object deletion is performed. Finally, a collision check with
/// any nearby bomb blocks is processed; "destroying" any that come in contact with the explosion's collider.
state_default = function(){
	// Keep checking to see if the flag for the animation's completion has been set. If so, the bomb explosion
	// will be flagged for deletion and no longer have a collision mask until that deletion has occurred.
	if (imageIndex == spriteLength - 1){
		stateFlags |= ENTT_DESTROYED;
		mask_index = spr_empty_mask;
		visible = false;
		return; // Object flagged for destruction, exit the state function prematurely.
	}
	
	// Check for collision with any destructible bomb blocks by using "instance_place_list". All instances that
	// are hit will be stored in the list and then looped through to destroy them if they aren't already.
	var _length = instance_place_list(x, y, par_destructible, collisionList, false);
	for (var i = 0; i < _length; i++){
		with(collisionList[| i]){
			if (ENTT_IS_DESTROYED || (object_index != obj_destructible_collectible_ball && 
					object_index != obj_destructible_all && object_index != obj_destructible_bomb)) 
				continue;
			destructible_destroy_self();
		}
	}
	if (_length > 0) {ds_list_clear(collisionList);}
	
	// Check for collision with enemies that come into contact with this explosion. If a collision is found, 
	// the enemy instance in question will be damaged if they are not immune to damage from standard bombs.
	_length	= instance_place_list(x, y, par_enemy, collisionList, false);
	for (var j = 0; j < _length; j++){
		with(collisionList[| j]){
			if (ENTT_IS_HIT_STUNNED || ENTT_IS_DESTROYED || !(weaknessFlags & ENMY_REGBOMB_WEAK))
				break;
			entity_apply_hitstun(BOMB_DAMAGE, BOMB_STUN_DURATION);
		}
	}
	if (_length > 0) {ds_list_clear(collisionList);}
	
	// Check for collision with the general door and also the inactive door (In case it's active) to see
	// if they should be opened by the bomb's explosion. Every other door type cannot be opened by the
	// bomb explosion, so they aren't even considered for collision.
	var _door = instance_place(x, y, obj_general_door);
	with(_door){
		var _isDestroyed = false;
		switch(object_index){
			case obj_general_door:	_isDestroyed = true;						break;
			case obj_inactive_door:	_isDestroyed = inactive_door_collision();	break;
		}
		
		// If the local flag is set to true after the switch statement has been processed, the door will
		// be opened by the bomb's explosion. Otherwise, nothing will happen to the door.
		if (_isDestroyed){
			if (flagID != EVENT_FLAG_INVALID)
				event_set_flag(flagID, true);
			stateFlags |= DOOR_OPENED;
			animSpeed	= 1.0;
		}
	}
}

#endregion