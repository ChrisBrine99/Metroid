/// @description Contains all the functions relating to movement of a par_entity child object. This also includes
/// movement used by par_entity_projectile children, since both objects are nearly identical in function. Both
/// objects can use most functions in this file, and the ones that can't be used by both will be specified.

/// @description Condenses the calculation for hspd and vspd, removal of fraction values, and a check for 
/// collision with the world. Finally, the _hspd and _vspd values are returned for any external use. 
/// (Ex. image_speed) 
///
/// NOTE THAT THIS IS ONLY USABLE IN CHILDREN OBJECTS OF par_entity!!!
///
/// @param inputDirection
/// @param instantVelocity
/// @param updateDirection
function update_position(_inputDirection, _instantVelocity, _updateDirection) {
	// Apply gravity to the entity if it applies to them. Entities with 0 gravity will ignore this chunk of code
	if (grav > 0 && !place_meeting(x, y + 1, par_block)){
		isGrounded = false;
		vspd += grav * global.deltaTime;
		if (vspd >= maxVspd){
			vspd = maxVspd;
		}
	} else if (!isGrounded && vspd >= 0){ // The entity has hit the floor; reset their grounded state
		isGrounded = true;
		hspd = 0;
		vspd = 0;
	}

	// Applying horizontal movement if the entity has a valid inputDirection value (1 or -1)
	if (_inputDirection != 0){
		if (_instantVelocity && ((_inputDirection == 1 && hspd < 0) || (_inputDirection == -1 && hspd > 0))){
			hspd = 0; // Reset hspd instantly whenever the input direction changes from left to right
		}
		hspd += _inputDirection * (accel * global.deltaTime);
		if (hspd > maxHspd){ // Maxing out rightward horizontal speed
			hspd = maxHspd;
		} else if (hspd < -maxHspd){ // Maxing out leftward horizontal speed
			hspd = -maxHspd;
		}
		// Optionally, flip the entity's sprite based on their current input direction
		if (_updateDirection){
			image_xscale = _inputDirection;
		}
	} else{ // Stopping horizontal movement
		var _accel = accel * global.deltaTime;
		hspd -= _accel * sign(hspd);
		if (hspd >= -_accel && hspd <= _accel){
			hspd = 0;
		}
	}
	// Finally, remove fractional values from the calculated delta values for horizontal and vertical velocity
	remove_movement_fractions();
}

/// @description Updates the position of an entity that is classified as a projectile. (Ex. They are children of
/// the object "par_entity_projectile") Gravity isn't applied to the object and instead 8-directional movement
/// is calculated; with acceleration if acceleration's on the x or y axis aren't set to 0, respectively.
///
/// NOTE THAT THIS IS MEANT FOR USE IN CHILDREN OBJECTS OF par_entity_projectile, BUT IT SHOULD WORK WITH
/// CHILDREN OF par_entity AS WELL!!!
///
function update_position_projectile(){
	// Horizontal Movement
	if (accel == 0){ // No acceleration; instantly set to maximum speed
		hspd = maxHspd * inputDirection[X];
	} else{ // Acceleration; slowly approach maximum speed in either direction
		hspd += accel * inputDirection[X];
		if (hspd < -maxHspd || hspd > maxHspd){
			hspd = maxHspd * inputDirection[X];
		}
	}

	// Vertical Movement
	if (grav == 0){ // No acceleration; instantly set to maximum speed
		vspd = maxVspd * inputDirection[Y];
	} else{ // Acceleration; slowly approach maximum speed in either direction
		vspd += grav * inputDirection[Y];
		if (vspd < -maxVspd || vspd > maxVspd){
			vspd = maxVspd * inputDirection[Y];
		}
	}
	// Finally, remove fractional values from the calculated delta values for horizontal and vertical velocity
	remove_movement_fractions();
}

/// @description Sets the entity's horizontal acceleration and the strength of gravity on them.
/// @param accel
/// @param gravity
function set_velocity_speed(_accel, _gravity){
	accel = max(0, _accel);
	grav = max(0, _gravity);
}

/// @description Sets the constant initial hspd and vspd to new values, with an optional argument that overwrites 
/// the current maximum values being used by the entity to the new constant values.
/// @param maxHspd
/// @param maxVspd
/// @param overwriteCurrent
function set_max_move_speed(_maxHspd, _maxVspd, _overwriteCurrent){
	maxHspdConst = max(0, _maxHspd);
	maxVspdConst = max(0, _maxVspd);
	if (_overwriteCurrent){
		reset_move_speed();
	}
}

/// @description Modifies the CURRENT maximum hspd and vspd (The initial constants remain the same) to the new 
/// values provided. if the modification has to be relative to the current maximum values, it will be added or
/// subtracted as such. Otherwise, it is chanced to the passed values.
/// @param hspdModifier
/// @param vspdModifier
/// @param relative
function modify_move_speed(_hspdModifier, _vspdModifier, _relative){
	if (_relative){
		maxHspd = max(0, maxHspd + _hspdModifier);
		maxVspd = max(0, maxVspd + _vspdModifier);
		return;
	}
	maxHspd = max(0, _hspdModifier);
	maxVspd = max(0, _vspdModifier);
}

/// @description Resets the CURRENT maximum hspd and vspd values back to their constant initial values.
function reset_move_speed(){
	maxHspd = maxHspdConst;
	maxVspd = maxVspdConst;
}