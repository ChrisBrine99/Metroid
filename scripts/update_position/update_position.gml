/// @description Condenses the calculation for hspd and vspd, removal of fraction values, and a check for 
/// collision with the world. Finally, the _hspd and _vspd values are returned for any external use. 
/// (Ex. image_speed)
/// @param inputDirection
/// @param instantVelocity

function update_position(_inputDirection, _instantVelocity) {
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
		// Flip the entity's sprite based on their current input direction
		image_xscale = _inputDirection;
	} else{ // Stopping horizontal movement
		var _accel = accel * global.deltaTime;
		hspd -= _accel * sign(hspd);
		if (hspd >= -_accel && hspd <= _accel){
			hspd = 0;
		}
	}
}