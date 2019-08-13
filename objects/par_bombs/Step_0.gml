/// @description Countdown Until the Bomb Explodes
// You can write your code in this editor

// Prevent the Bomb From Exploding When the Game is Paused
if (global.gameState == GAME_STATE.PAUSED){
	return;
}

// Countdown Until the Bomb Explodes
explodeTime = scr_update_value_delta(explodeTime, -1);
if (explodeTime <= 15 && explodeTime > 0){
	imgSpd = 2;
} else if (explodeTime <= 0){
	// Create the set explosion effect
	if (setExplodeFX != noone){
		instance_create_depth(x, y, 45, setExplodeFX);
	}
	instance_destroy(self);
}