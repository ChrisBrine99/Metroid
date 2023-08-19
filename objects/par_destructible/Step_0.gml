// Don't process the respawning logic for the destructible if any of the three conditions are met: the object isn't
// set to respawn based on its "timeToRespawn" value, it isn't considered "destroyed", or its effect variable has
// a valid instance ID stored in it currently.
if (timeToRespawn != RESPAWN_TIMER_INFINITE || !IS_DESTROYED || effectID != noone) {return;}

// Increment the respawn timer by the current value of delta time until it surpasses the required time interval
// After this, the block will "rebuild" itself; playing the blcok regeneration animation if it has its flag for
// using effects toggled to true.
respawnTimer += DELTA_TIME;
if (respawnTimer > timeToRespawn){
	// Reset the object's "DESTROYED" flag, and reset the respawn timer to its default value.
	stateFlags	&= ~(1 << DESTROYED);
	respawnTimer = 0.0;
	
	// Don't continue executing this event's code if the object isn't allows to use destruction/regen effects.
	if (!CAN_USE_EFFECTS) {return;}
	
	// Create some local values that will store the current position of the destructible object, as well as
	// its ID value so the effect struct can reference its creator when necessary.
	var _x	= x;
	var _y	= y;
	var _id	= id;
	
	// Create an instance of the "obj_destructible_effect" struct; storing its instance ID. After this, scope
	// is handed off to this instance and all the values stored in local variables are copied over.
	effectID = instance_create_struct(obj_destructible_effect);
	with(effectID){
		x			= _x;
		y			= _y;
		parentID	= _id;
		imageIndex	= REGEN_ANIM_EFFECT - 1;	// Set the animation to play in reverse.
		animSpeed	= -1.0;
	}
}