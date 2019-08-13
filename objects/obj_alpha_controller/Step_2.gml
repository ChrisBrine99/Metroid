/// @description Increase/Decrease the alpha value
// You can write your code in this editor

if (freezeOnPause){
	if (global.gameState == GAME_STATE.PAUSED){
		return;	
	}
}

if (fadingIn){
	if (alpha >= 1){ // Stop the alpha level from increasing past full opaque
		alpha = 1;
	} else{ // Smoothly fade the object into visibility
		alpha = scr_update_value_delta(alpha, alphaChangeVal);	
	}
} else{
	if (alpha <= 0){ // Stop the alpha level from decreasing past full transparency
		alpha = 0;
		if (destroyOnZero){ // Destroy the instance
			instance_destroy(self);
		}
	} else{ // Smoothly fade the object away
		alpha = scr_update_value_delta(alpha, -alphaChangeVal);	
	}
}