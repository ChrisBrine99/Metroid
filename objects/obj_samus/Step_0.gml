/// @description Getting Keyboard Input and Executing Non-State Code

// If there is no state to execute or the game state is set to paused; don't allow entity functionality
if (curState == -1 || global.gameState != GameState.InGame){
	image_speed = 0;
	return;
}

// Update keyboard input
keyRight = keyboard_check(vk_right);
keyLeft = keyboard_check(vk_left);
keyUp = keyboard_check(vk_up);
keyDown = keyboard_check(vk_down);
keyAuxUp = keyboard_check_pressed(vk_up);
keyAuxDown = keyboard_check_pressed(vk_down);
keyJumpStart = keyboard_check_pressed(ord("X"));
keyJumpEnd = keyboard_check_released(ord("X"));
keyWeapon = keyboard_check_pressed(ord("Z"));

// Aiming Upward/Downward
if (keyUp && !keyDown){ // Aiming up (Both grounded and airbourne)
	aimDirection = AIM_UPWARD;
} else if (!isGrounded && keyDown && !keyUp){ // Aiming down (Airbourne only)
	aimDirection = AIM_DOWNWARD;
} else{ // Aiming forward (Standard direction)
	aimDirection = AIM_FORWARD;
}

// Call the par_entity step event
event_inherited();

// Using Samus's currently equipped weapon
if (keyWeapon && canUseWeapon){
	isShooting = true;
	shootTimer = 0;
	// Don't try creating a weapon object (projectile, bomb) if no script exists to create it.
	if (weaponScript != -1){
		var _weaponOffset = [0, 0];
		// Find out the offset relative to the stat Samus if currently in
		if (curState == state_samus_morphball){
			_weaponOffset[Y] = 16;
		} else if (isGrounded){ // The weapon spawn offset when Samus is on the ground
			if (curState == state_samus_crouch){
				_weaponOffset[X] = 11;
				_weaponOffset[Y] = 7;
			} else{
				if (hspd > -1 && hspd < 1){
					var _offsets = [12, -3, 3, -22];
					_weaponOffset[X] = _offsets[aimDirection * 2];
					_weaponOffset[Y] = _offsets[(aimDirection * 2) + 1];
				} else{
					var _offsets = [17, -7, 17, -6, 17, -7, 4, -23, 4, -22, 4, -23];
					_weaponOffset[X] = _offsets[(aimDirection * 6) + (floor(curFrame) * 2)];
					_weaponOffset[Y] = _offsets[(aimDirection * 6) + (floor(curFrame) * 2) + 1];
				}
			}
		} else{ // The weapon spawn offset whenever Samus is airbourne
			var _offsets = [13, -1, 4, -22, 5, 9];
			_weaponOffset[X] = _offsets[aimDirection * 2];
			_weaponOffset[Y] = _offsets[(aimDirection * 2) + 1];
		}
		// Spawn the weapon using its associated script at the given offset
		script_execute(weaponScript, _weaponOffset[X], _weaponOffset[Y]);
	}
}
// Counting down the shooting flag reset timer
if (isShooting){
	shootTimer += global.deltaTime;
	if (shootTimer > 15){
		isShooting = false;
		shootTimer = 0;
	}
}