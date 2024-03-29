#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
___initialize = initialize;
/// @description 
/// @param {Function}	state			The state to initially use for the projectile in question. 
/// @param {Real}		x				Samus's horizontal position in the room.
/// @param {Real}		y				Samus's vertical position in the room.
/// @param {Real}		playerFlags		
/// @param {Bool}		flags
initialize = function(_state, _x, _y, _playerFlags, _flags){
	___initialize(_state, _x, _y, _playerFlags, _flags); // Calls initialize function found in "par_player_projectile".
	// Determine if the missile is a standard missile or an upgraded "super" missile. The upgrade is an upgrade
	// that will transform the standard missile to move faster, deal more damage, and allow damage to certain
	// enemies that were once impervious to it.
	if (event_get_flag(FLAG_SUPER_MISSILES)){
		entity_set_sprite(spr_super_missile, -1);
		stateFlags |= PROJ_SUPMISSILE;
		damage		= 16;	// Damage is quadruplued.
		maxHspd		= 12.0;	// Maximum speed is increased.
		maxVspd		= 12.0;
		hAccel		= 0.75;	// Start-up acceleration is heavily improved.
		vAccel		= 0.75;
	} else{ // Missile not upgraded; remains standard.
		entity_set_sprite(spr_missile, -1);
		stateFlags |= PROJ_REGMISSILE;
		damage		= 4;	// Base missile does 4.0x the damage of an uncharged powerbeam.
		maxHspd		= 8.5;	// Maximum horizontal and vertical celocity.
		maxVspd		= 8.5;
		hAccel		= 0.2;	// Horizontal and vertical acceleration.
		vAccel		= 0.2;
	}
}

#endregion

#region State functions

/// @description The missile's default movement state, which will have it slowly accelerate frame-by-frame
/// until it hits its maximum velocity in whatever direction is it moving in. After that, calls to the general
/// collision functions are performed.
state_default = function(){
	// Handling movement (Which can be either horizontal or vertically depending on if Samus was aiming forward,
	// upward, or downward as the missile was fired). The missile will slowly accelerate until is maximum speed
	// has been reached. After that, it will continue to move at that max speed until the missile is destroyed.
	if (PROJ_MOVING_HORIZONTAL){
		hspd += hAccel * sign(image_xscale) * DELTA_TIME;
		if (hspd < -maxHspd)		{hspd = -maxHspd;}
		else if (hspd > maxHspd)	{hspd = maxHspd;}
	} else if (PROJ_MOVING_VERTICAL){
		vspd += (image_angle == 90.0) ? -vAccel * DELTA_TIME : vAccel * DELTA_TIME;
		if (vspd < -maxVspd)		{vspd = -maxVspd;}
		else if (vspd > maxVspd)	{vspd = maxVspd;}
	}
	
	// After the acceleration has been applied to the missile for the current frame, the collision and movement
	// for the frame will be processed; and any collisions with destructible objects directly after that.
	apply_frame_movement(projectile_world_collision);
	
	// Whenever the missile is destroyed, it will create an explosion effect and optionally a camera shake to
	// go along with that missile explosion in the super missile's case. That is done here and not the destroy
	// event in order to prevent the explosion for being created by the missile being destroyed by just going
	// off-screen.
	if (ENTT_IS_DESTROYED){
		if (stateFlags & PROJ_SUPMISSILE){ // Super missile's destruction effects.
			// -- Create super missile explosion effect here -- // 
			camera_set_shake(5, 15);
		} else{ // Standard missile's destruction effects.
			// -- Create missile explosion effect here -- //
		}
	}
}

#endregion