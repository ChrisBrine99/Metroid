/// @description Move the Sprite to its Ending Position
// You can write your code in this editor

if (fadeID != noone){
	if (fadeID.alpha == 1){
		// Set the ending position of the sprite
		if (endXPos == 0 && endYPos == 0){
			if (room != curRoom){
				endXPos = obj_player.x;
				endYPos = obj_player.y;
			}
		} else{ // Move toward final position
			x += (endXPos - x) / transitionSpd;
			y += (endYPos - y) / transitionSpd;
		}
	}
}