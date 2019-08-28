/// @description Fading the Text In and Out
// You can write your code in this editor

scr_alpha_control_update();

// When the text disappears
if (displayTimer <= 0){
	fadingIn = false;
} else{
	displayTimer = scr_update_value_delta(displayTimer, -1);
	// Freezing the player
	if (freezePlayer){
		with(obj_player) {canMove = false;}	
	}
}