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