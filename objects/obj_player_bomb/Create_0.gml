#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Use the inherited hitpoint variables as a timer that will result in the bomb exploding after said hitpoint
// value reaches or goes below 0. The "maxHitpoints" variable stores the total time it takes for the bomb to
// detonate; used for comparing against the time remaining in order to speed up the bomb animation after a
// certain point.
maxHitpoints = 60;
hitpoints = maxHitpoints;

#endregion

#region Unique variable initialization
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
	entity_set_sprite(spr_player_bomb, spr_empty_mask);
	stateFlags |= (1 << DRAW_SPRITE);
}

#endregion

#region State function initializations

/// @description The bomb's sole state function. It will count down its life timer until it goes below zero.
/// Once that condition has been met, the bomb will create its explosion object and flag itself for deletion.
/// Also, once the timer goes below 25% its initial value, the sprite animation will speed up considerably.
state_default = function(){
	hitpoints -= DELTA_TIME;
	if (hitpoints <= 0){
		// Create the explosion object, and the call its initialization function or else the explosion will
		// exist, but not be visible or functional in the game world.
		var _id = instance_create_object(x, y, obj_player_bomb_explode, depth);
		with(_id) {initialize(state_default);}
		
		// Remove the state from this object and let the game know to destroy it at the start of the next frame.
		object_set_next_state(NO_STATE);
		stateFlags |= (1 << DESTROYED);
		visible = false;
	}
	
	// Increasing the speed of the bomb's animation to signify it's close to exploding.
	if (hitpoints < (maxHitpoints * 0.25) && animSpeed == 1) {animSpeed = 3;}
}

#endregion