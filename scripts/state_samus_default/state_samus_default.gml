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