/// @description Fading the Text In and Out
// You can write your code in this editor

// When the text disappears
if (displayTimer <= 0){
	if (alpha > 0){
		alpha -= 0.1;
	} else{
		instance_destroy(self);
		// Unfreezing the player
		if (freezePlayer){
			with(obj_player) {canMove = true;}
		}
	}
} else{
	if (alpha < 1){
		alpha += 0.1;	
	}
	displayTimer--;
	// Freezing the player
	if (freezePlayer){
		with(obj_player) {canMove = false;}	
	}
}