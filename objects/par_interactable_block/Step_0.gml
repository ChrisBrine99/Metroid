/// @description Colliding with the Player
// You can write your code in this editor

#region Preventing Object Function When Player Cannot Move (Ex. Cutscene, in a menu, etc.)

// Don't allow the player to collide with an interactable object whent the game is paused
if (global.gameState != GAME_STATE.IN_GAME){
	image_speed = 0;
	return;	
}
image_speed = 1;

#endregion

#region Destroy when collected

if (place_meeting(x, y, obj_player)){
	global.item[index + subIndex] = true;
	// TODO -- Create an item screen prompt object to display item information.
	instance_destroy(self);
}

#endregion

#region Dynamically changing the Light size depending on the current image being displayed

if (ambLight != noone){
	switch(floor(image_index)){
		case 0: // The "Bright" state
			ambLight.xRad = 38;
			ambLight.yRad = 38;
			break;
		case 1: // The "Normal" state
			ambLight.xRad = 26;
			ambLight.yRad = 26;
			break;
	}
}

#endregion