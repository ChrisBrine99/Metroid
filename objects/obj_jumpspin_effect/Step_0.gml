/// @description Insert description here
// You can write your code in this editor

if (global.gameState != GAME_STATE.IN_GAME){
	return;	
}

// Update the Alpha Level
scr_alpha_control_update();

// Create another of these effects
if (alpha <= 0.2 && !hasSpawned){
	hasSpawned = true;
	with(obj_player){
		if (!onGround && jumpspin){
			instance_create_depth(x, y, depth + 1, obj_jumpspin_effect);
		}
	}
}