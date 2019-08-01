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

if (!global.item[index + subIndex]){
	if (place_meeting(x, y, obj_player)){
		global.item[index + subIndex] = true;
		// Create the Item Information Screen
		var obj = instance_create_depth(0, 0, 15, obj_new_item_prompt);
		obj.displayTxt = itemDescription;
		obj.itemName = itemName;
		obj.scrollingText = scrollingText;
		obj.nameCol = nameCol;
		obj.nameOCol = nameOCol;
		obj.creatorID = id;
		obj.fanfare = fanfare;
		// Play the designated fanfare
		audio_pause_all();
		scr_play_sound(fanfare, 0, false, true);
	}
}

#endregion

#region Dynamically changing the Light size depending on the current image being displayed

if (ambLight != noone){
	switch(floor(image_index)){
		case 0: // The "Bright" state
			with(ambLight){
				xRad = 38;
				yRad = 38;
			}
			break;
		case 1: // The "Normal" state
			with(ambLight){
				xRad = 26;
				yRad = 26;
			}
			break;
	}
}

#endregion