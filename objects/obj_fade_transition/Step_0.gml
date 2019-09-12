/// @description Handling Alpha Level
// You can write your code in this editor

scr_alpha_control_update();

if (fadingIn){ // Fade in and count down frames before fade out
	if (alpha >= 1 - alphaChangeVal){
		var canFade = true;
		// Check if the transition needs to wait for the sprite sweeping object is at it's final position
		if (effectID != noone){
			with(effectID){
				if (abs(x - endXPos) >= 1 && abs(y - endYPos) >= 1){ // Disable fade away
					canFade = false;
				}
			}
		}
		// Countdown until the rectangles begins fading away
		if (canFade){
			opaqueTime = scr_update_value_delta(opaqueTime, -1);
			if (opaqueTime <= 0){
				fadingIn = false;
			}
		}
		alpha = 1;
	}
} else{
	if (alpha <= alphaChangeVal){
		if (effectID != noone) {instance_destroy(effectID);}
		// Unfreezing when the user is in-game (AKA the player object exists)
		if (instance_exists(obj_player)){
			global.gameState = GAME_STATE.IN_GAME;
			with(obj_hud) {isVisible = true;}
		}
		instance_destroy(self);
	}
}