#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Unique variable initializations

//
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
	stateFlags |= (1 << DRAW_SPRITE);
}

#endregion

#region State function initialization

/// @description A simple state that performs two things when called. First, a check to see if its explosion
/// animation has ended so it can be flagged for object deletion is performed. Finally, a collision check with
/// any nearby bomb blocks is processed; "destroying" any that come in contact with the explosion's collider.
state_default = function(){
	// Keep checking to see if the flag for the animation's completion has been set. If so, the bomb explosion
	// will be flagged for deletion and no longer have a collision mask until that deletion has occurred.
	if (DID_ANIMATION_END){
		stateFlags |= (1 << DESTROYED);
		imageIndex = spriteLength - 1;
		animSpeed = 0;
		mask_index = spr_empty_mask;
		visible = false;
		return; // Object flagged for destruction, exit the state function prematurely.
	}
	
	// Check for collision with any destructible bomb blocks by using "instance_place_list". All instances that
	// are hit will be stored in the list and then looped through to destroy them if they aren't already.
	var _length = instance_place_list(x, y, par_destructible, collisionList, false);
	for (var i = 0; i < _length; i++){
		with(collisionList[| i]){
			if (IS_DESTROYED || (object_index != obj_destructible_collectible_ball && 
								 object_index != obj_destructible_all && 
								 object_index != obj_destructible_bomb)) {continue;}
			destructible_destroy_self();
		}
	}
	if (_length > 0){ds_list_clear(collisionList);}
}

#endregion