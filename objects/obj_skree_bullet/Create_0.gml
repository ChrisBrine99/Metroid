#region Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Determines the maximum possible velocities for the Skree's Bullet, which are used along with the direction 
// of the projectile to determine the proper x and y velocities for the bullet.
maxHspd = 8.0;
maxVspd = 8.0;

// Instead of being used in the traditional sense, the Skree bullet will use its max hitpoint variable to 
// determine the amount of time in seconds (60 units == 1 second) the bullet will exist for before it is 
// destroyed automatically (If no collision with the player happens before then).
maxHitpoints	= SKRE_POST_DEATH_TIME * 0.75;

// Set the damage output and hitstun duration for the Skree's bullet. These values are increased/decreased by 
// the difficulty level selected by the player.
damage			= 10;
stunDuration	= 10;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Skree bullet, which is 
/// then called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Simply initialized the bullet instance to use the proper sprite.
/// @param {Function} state		The function to use for this bullet's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_skree_bullet, -1);
}

#endregion

#region State function initializations

/// @description The Skree bullet's one and only state function. All it does it count the duration of the
/// instance's existance to see if that value exceeds the value stored in "maxHitpoints". If it does, the bullet
/// is destroyed. Otherwise, the bullet has its position updated; checking for collision with the player after
/// the position update.
state_default = function(){
	// Increment the bullet's hitpoint value by delta time until it surpasses the max hitpoint value. The bullet
	// is turned invisible, toggled to be destroyed at the start of the next frame, and the state is cleared.
	hitpoints += DELTA_TIME;
	if (hitpoints >= maxHitpoints){
		object_set_next_state(NO_STATE);
		stateFlags &= ~(1 << DRAW_SPRITE);
		stateFlags |=  (1 << DESTROYED);
		return;
	}
	
	// Perform the current frame's movement by calling the default function for entity movement and collision
	// handling. After that process is completed, a collision check against the player object is performed if
	// the bullet instance wasn't destroyed by colliding with the world.
	apply_frame_movement(entity_world_collision, false);
	if (!IS_DESTROYED) {projectile_player_collision();}
}

#endregion

// Once the create event has executed, initialize the Skree Bullet by setting it to its default state function.
initialize(state_default);