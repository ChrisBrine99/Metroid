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