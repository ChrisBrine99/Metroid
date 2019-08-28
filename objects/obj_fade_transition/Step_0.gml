/// @description Handling Alpha Level
// You can write your code in this editor

scr_alpha_control_update();

if (fadingIn){ // Fade in and count down frames before fade out
	if (alpha == 1){
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
	}
} else{
	if (alpha <= 0){
		if (effectID != noone) {instance_destroy(effectID);}
		with(obj_hud) {isVisible = true;}	
		instance_destroy(self);
	}
}