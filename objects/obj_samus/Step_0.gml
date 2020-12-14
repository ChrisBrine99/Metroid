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
if (curState != state_samus_crouch && keyUp && !keyDown){ // Aiming up (Both grounded and airbourne)
	aimDirection = AIM_UPWARD;
} else if (!isGrounded && keyDown && !keyUp){ // Aiming down (Airbourne only)
	aimDirection = AIM_DOWNWARD;
} else{ // Aiming forward (Standard direction)
	aimDirection = AIM_FORWARD;
}

// Call the par_entity step event
event_inherited();

// Counting down the shooting flag reset timer
if (isShooting){
	shootTimer += global.deltaTime;
	if (shootTimer >= 20){
		isShooting = false;
		shootTimer = 0;
	}
}