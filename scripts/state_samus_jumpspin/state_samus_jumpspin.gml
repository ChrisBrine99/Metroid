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