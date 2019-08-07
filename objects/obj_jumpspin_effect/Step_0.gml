/// @description Insert description here
// You can write your code in this editor

if (global.gameState != GAME_STATE.IN_GAME){
	return;	
}

// Lower the alpha until the sprite is invisible, otherwise remove this instance
alpha -= 0.1;
// Create another of these effects
if (alpha == 0.2){
	with(obj_player){
		if (!onGround && jumpspin){
			instance_create_depth(x, y, depth + 1, obj_jumpspin_effect);
		}
	}
}
// Destroy the effect if the player start shooting in midair or when the image is invisible
if (alpha <= 0){
	instance_destroy(self);	
}