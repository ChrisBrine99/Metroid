/// @description Colliding with the Player
// You can write your code in this editor

#region Preventing Object Function When Player Cannot Move (Ex. Cutscene, in a menu, etc.)

// Don't allow the player to collide with an interactable object whent the game is paused
if (global.gameState != GAME_STATE.IN_GAME){
	// Don't draw the ambient light if the item is hidden
	if (instance_place(x, y, par_destructable_block) != noone){
		visible = false;
		ambLight.canDraw = false;
	}
	return;	
}

#endregion

#region Destroy when collected

// Check if the object is hidden
var blockAbove = instance_place(x, y, par_destructable_block);
if (blockAbove != noone){
	if (!isHidden){
		visible = false;
		isHidden = true;
		ambLight.canDraw = false;
	}
} else{
	if (isHidden){
		visible = true;
		isHidden = false;
		ambLight.canDraw = true;
	}
}
// Check for collision with the item only when the object is visible
if (!isHidden && !global.item[index + subIndex]){
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