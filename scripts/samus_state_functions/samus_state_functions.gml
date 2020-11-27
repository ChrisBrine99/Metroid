/// @description This file contains all the state scripts used by Samus. These include her default state, jumping
/// state, morphball, crouching, hit recoil, and so on.

/// @description The state Samus is in when the game first begins and her fanfare is playing. Once the fanfare
/// has completed playing, pressing left or right will change Samus's state to her default.
function state_samus_intro(){
	if ((keyRight && !keyLeft) || (keyLeft && !keyRight)){
		set_cur_state(state_samus_default);
		image_xscale = keyRight - keyLeft;
		return;
	}
	sprite_update(sprStandStart, false);
}

/// @description Samus's default state. From here, she'll be about to move left and right, jump, shoot her currently
/// equipped weapon, crouch, and enter morphball. Some of these will take the player to different state, and some
/// are all contained within here.
function state_samus_default() {
	// Set Samus's current direction based on keyboard input
	inputDirection = keyRight - keyLeft;

	// Entering Samus's crouching state
	if (keyAuxDown && isGrounded){
		set_cur_state(state_samus_crouch);
		mask_index = spr_crouching_mask;
		lightPosition[Y] = 8; // Offset the center of the light
		hspd = 0;
		return;
	}

	// Starting a jump from the ground
	if (keyJumpStart && isGrounded){
		vspdFraction = 0;
		vspd = jumpSpeed;
		if (inputDirection != 0 && !isShooting){ // Jumping while not shooting and moving
			set_cur_state(state_samus_jumpspin);
			mask_index = spr_jumping_mask;
		} else{ // Jumping while shooting or while standing still
			set_cur_state(state_samus_jump);
			mask_index = spr_jumping_mask;
			accel /= 3; // Cut Samus's acceleration while airbourne
		}
	}

	// Update Samus's current horizontal and vertical positions; apply gravity as well.
	update_position(inputDirection, true);
	entity_world_collision_complex(false);

	// If the player is no longer grounded after the position update, set the state to the standard jump
	if (!isGrounded && curState == state_samus_default){
		set_cur_state(state_samus_jump);
		mask_index = spr_jumping_mask;
		accel /= 3; // Cut Samus's acceleration while airbourne
	}
	
	// Animate based on what Samus is currently doing right now, relative to this state
	if (hspd > -1 && hspd < 1){
		if (aimDirection == AIM_FORWARD){
			sprite_update(sprStandFwd, false);
		} else if (aimDirection == AIM_UPWARD){
			sprite_update(sprStandUp, false);
		}
	} else{
		if (aimDirection == AIM_FORWARD){
			if (!isShooting){ // Samus will not have her gun aimed forward
				sprite_update(sprWalkFwd, false);
			} else{ // Samus's gun will be out and aimed forward
				sprite_update(sprWalkFwdShoot, false);
			}
		} else if (aimDirection == AIM_UPWARD){
			sprite_update(sprWalkUp, false);
		}
	}
}

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

/// @description Samus's staet whenever she is in her morphball mode. From here she can drop bombs/power bombs
/// move through small passageways, and enter her spiderball mode. To exit this form, the player must press up
/// in a place where there is room overhead; otherwise, she will not transform.
function state_samus_morphball(){
	// Set Samus's current direction based on keyboard input
	inputDirection = keyRight - keyLeft;

	// Exiting from morphball mode when there is enough space
	if (keyAuxUp && isGrounded && !place_meeting(x, y - 14, par_block)){
		sprite_update(sprCrouchFwd, true, sprEnterMorphball, 20);
		set_cur_state(state_samus_crouch);
		mask_index = spr_crouching_mask;
		lightPosition[Y] = 8; // Offset the center of the light
		return;
	}

	// Jumping with the spring ball
	if (keyJumpStart && isGrounded){
		vspdFraction = 0;
		vspd = jumpSpeedMorph;
	}

	// Update Samus's position relative to her current hspd and vspd values, but keep track of her initial vspd
	// before gravity/collision is calculated. Then, if the previous vspd was high enough upon hitting the ground,
	// the morphball will bounce as a sort of "recoil" from hitting the ground too hard.
	var _prevVspd = vspd;
	update_position(inputDirection, isGrounded);
	entity_world_collision_complex(false);
	if (isGrounded && _prevVspd >= 3){
		vspd = -_prevVspd / 2.5;
	}

	// Animate based on what Samus is currently doing right now, relative to this state
	sprite_update(sprMorphball, true, sprEnterMorphball, 20);
}

/// @description Samus's state for being airbourne, but not while spinning in the air. This means that she
/// cannot activate her screw attack or space jump while in this state.
function state_samus_jump(){
	// Activating Samus's spin while airbourne and stationary
	if (keyJumpStart && aimDirection == AIM_FORWARD){
		set_cur_state(state_samus_jumpspin);
		sprite_update(sprJumpSpin, true); // Ignore the transition sprite
		accel *= 3; // Reset Samus's acceleration back to normal
		inputDirection = image_xscale;
		hspd = (maxHspd - 1) * image_xscale;
		vspd = 0;
		return; // Exit early to prevent inputDirection being overwritten
	}
	// Stopping a jump before its full height can be reached
	if (keyJumpEnd && vspd < 0){
		vspd /= 2;
	}

	// Set Samus's current direction based on keyboard input
	inputDirection = keyRight - keyLeft;

	// Update Samus's current horizontal and vertical positions; apply gravity as well.
	update_position(inputDirection, false); // False will make it harder to turn while spinning in the air
	entity_world_collision_complex(false);
	// Instantly return to the default state once the ground has been hit
	if (isGrounded){
		set_cur_state(state_samus_default);
		mask_index = spr_standing_mask;
		y -= 6; // Fix offset to stop from clipping into the ground
		accel *= 3; // Reset Samus's acceleration when she lands
		return;
	}

	// Animate based on what Samus is currently doing right now, relative to this state
	if (aimDirection == AIM_FORWARD){
		sprite_update(sprJumpFwd, false);
	} else if (aimDirection == AIM_UPWARD){
		sprite_update(sprJumpUp, false);
	} else if (aimDirection == AIM_DOWNWARD){
		sprite_update(sprJumpDown, false);
	}
}

/// @description Jumping while spinning in the air. This allows for Samus to jump again if she has the space
/// jump item. Once Samus collides with the floor again she'll be put back into the default state. Also, the
/// screw attack will automatically activate in this state if Samus has the item activated.
function state_samus_jumpspin(){
	// Jumping again while airbourne and spinning (Space Jump only)
	if (keyJumpStart && vspd >= 2.5){
		vspd = jumpSpeed;
		// TODO -- Add space jump code here
	}
	// Stopping a jump before its full height can be reached
	if (keyJumpEnd && vspd < 0){
		vspd /= 2;
	}

	// Set Samus's current direction based on keyboard input
	var _inputDirection = keyRight - keyLeft;
	if (_inputDirection != 0){ // Only update the movement direction when a direction is being pressed
		inputDirection = keyRight - keyLeft;
	}

	// Update Samus's current horizontal and vertical positions; apply gravity as well.
	update_position(inputDirection, false); // False will make it harder to turn while spinning in the air
	entity_world_collision_complex(false);
	// Instantly return to the default state once the ground has been hit
	if (isGrounded){
		set_cur_state(state_samus_default);
		mask_index = spr_standing_mask;
		y -= 6; // Fix offset to stop from clipping into the ground
		return;
	}

	// If Samus changes her aiming direction OR begins shooting; change to the standard jump
	if (aimDirection != AIM_FORWARD || isShooting){
		set_cur_state(state_samus_jump);
		accel /= 3;  // Cut Samus's acceleration while airbourne
		return;
	}

	// Only one sprite occurs during this state; always set current one to it.
	sprite_update(sprJumpSpin, true, sprJumpFwd, 15);
}

/// @description The state for when samus is recoiling from an attack. It lasts for 10 frames of her 1 second
/// invincibility timer. While in this state, the player can't make Samus shoot, move, or aim in any direction.
/// She will recoil backwards from her facing direction and upwards slightly as well.
function state_samus_hurt(){
	if (curState != state_samus_hurt){
		set_cur_state(state_samus_hurt);
		inputDirection = -image_xscale;
		vspd = -3.5;
	}

	// Update Samus's current horizontal and vertical positions; apply gravity as well.
	update_position(inputDirection, true);
	entity_world_collision_complex(false);
	// If Samus is on the ground after updating her position, reset her state
	if ((vspd >= 0 && isGrounded) || recoveryTimer <= max(1, timeToRecover - 10)){
		set_cur_state(state_samus_default);
	}
}