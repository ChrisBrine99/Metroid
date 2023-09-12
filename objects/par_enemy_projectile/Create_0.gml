#region Macros that are useful/related to par_enemy and its children
#endregion

#region Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Initializing unique variables

// Stores the damage prior to any damage reduction due to difficulty settings or Samus's current suit upgrades.
// The stun duration determines how long in "unit frames" (60 = 1 real-world second), to prevent any input from
// the player after Samus takes damage.
damage		 = 0;
stunDuration = 0.0;

// Stores the coordinates the projectile was at during the beginning of a given frame. These values are then
// used to check for collision with the player AFTER movement has been processed for that same frame.
startX = 0;
startY = 0;

#endregion

#region Default initialize function override

/// @description The default initialization function for an Enemy Projectile entity. By default, they will all 
/// be toggled to visible while also having their loop animation and "destroy on wall collision" flags flipped 
/// to true.
/// @param {Function}	state	The function to use for this entity's initial state.
initialize = function(_state){
	object_set_next_state(_state);
	stateFlags	   |= (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION) | (1 << DESTRUCTIBLE);
	visible			= true;
}

#endregion

#region Utility function initialization

/// @description Function that will check for a collision between the projectile instance and Samus. This function
/// should always be called immediately after movement for the frame has been applied onto the projectile in
/// question.
projectile_player_collision = function(){
	// Don't bother checking for a collision if the projectile instance calling this function hasn't moved from
	// its frame start coordinates so a pointless "collision_line" check isn't processed.
	if (startX == x && startY == y) 
		return;
	
	// Also ignore checking for collision if Samus is already recovering or stunned from a previous attack.
	with(PLAYER){
		if (IS_HIT_STUNNED)
			return;
	}
	
	// Perform the collision check from the projectile's frame starting coordinates and the coordinates it is
	// currently at against the unique player object instance (Samus). If it returns its instance ID value, the
	// collision will have occurred and the projectile should be destroyed; damaging Samus if possible.
	if (collision_line(startX, startY, x, y, PLAYER, false, true) != noone){
		stateFlags &= ~(1 << DRAW_SPRITE);
		stateFlags |=  (1 << DESTROYED);
		
		// Copy over the projectile's damage and stun duration values by storing them in local values. These
		// values go unused if Samus is performing a screw attack, as that ability's use makes her invulnerable
		// to all forms of damage. Otherwise, her hitstun function is called to apply the damage onto her.
		var _damage		= damage;
		var _hitstun	= stunDuration;
		with(PLAYER){
			if (IS_JUMP_ATTACK)
				return;
			entity_apply_hitstun(_hitstun, _damage);
		}
	}
}

#endregion