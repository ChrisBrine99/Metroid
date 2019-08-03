/// @description Handling Alpha Level
// You can write your code in this editor

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
			opaqueTime--;
			if (opaqueTime <= 0){
				fadingIn = false;
			}
		}
	} else{
		alpha += alphaIncr;	
	}
} else{ // Fade out and destroy self/sprite sweep object if it exists
	alpha -= alphaIncr;
	if (alpha <= 0){
		instance_destroy(self);	
		if (effectID != noone) {instance_destroy(effectID);}
	}
}