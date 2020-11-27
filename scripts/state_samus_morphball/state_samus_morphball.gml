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