/// @description Move the Sprite to its Ending Position
// You can write your code in this editor

if (fadeID != noone){
	if (fadeID.alpha == 1){
		// Set the ending position of the sprite
		if (endXPos == 0 && endYPos == 0){
			if (room != curRoom){
				// Update the camera to the correct position
				with(obj_camera){
					x = curObject.x;
					y = curObject.y;
					scr_camera_bounds(0, 0, room_width, room_height);
					global.camX = x - (global.camWidth / 2);
					global.camY = y - (global.camHeight / 2);  	
				}
				// Set the ending position based on the resulting camera positions
				endXPos = obj_player.x - global.camX;
				endYPos = obj_player.y - global.camY;
			}
		} else{ // Move toward final position
			x += (endXPos - x) / transitionSpd;
			y += (endYPos - y) / transitionSpd;
		}
	}
}