/// @description The state Samus is in when she is crouching. From here, the player can hold a directional key for
/// a set number of frames to stand back up OR press up to enter her default state once again. Also, Samus can
/// enter morphball mode if she has the morphball equipped.

function state_samus_crouch() {
	// Set Samus's current direction based on keyboard input
	inputDirection = keyRight - keyLeft;
	// Counting down the stand timer whenever an input is found
	if (inputDirection != 0){
		standTimer += global.deltaTime;
	} else{ // Resets the standing timer
		standTimer = 0;
	}

	// Exiting from the crouching state only where there is ample space above Samus's head
	if (((keyAuxUp && !keyAuxDown) || keyJumpStart || standTimer >= 10) && !place_meeting(x, y - 10, par_block)){
		set_cur_state(state_samus_default);
		mask_index = spr_standing_mask;
		lightPosition[Y] = 0; // Reset the offset
		standTimer = 0;
		return;
	}

	// Entering morphball mode
	if (keyAuxDown && !keyAuxUp){
		// TODO -- Add check for morphball here
		set_cur_state(state_samus_morphball);
		mask_index = spr_morphball_mask;
		lightPosition[Y] = 15; // Offset the center of the light
		standTimer = 0;
		return;
	}

	// Animate based on what Samus is currently doing right now, relative to this state
	sprite_update(sprCrouchFwd, false);
	if (inputDirection != 0){ // Flip sprite based on direction
		image_xscale = inputDirection;
	}
}