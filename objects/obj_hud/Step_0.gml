/// @description Handling HUD opacity
// You can write your code in this editor

// Fading the HUD in and out
if (isVisible){
	alpha += 0.1;
	if (alpha > 1){
		alpha = 1;
	}
} else{
	alpha -= 0.1;
	if (alpha < 0){
		alpha = 0;	
	}
}