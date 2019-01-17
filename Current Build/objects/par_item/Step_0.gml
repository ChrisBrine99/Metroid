/// @description Handling collision with the player
// You can write your code in this editor

if (instance_exists(obj_item_ball)){
	hidden = true;	
	return;
}
hidden = false;

// Collect the item
if (place_meeting(x, y, obj_samus) && !global.itemCollected){
	global.itemCollected = true;
	audio_pause_all();
	// Play the item fanfare
	global.itemTheme = themeToPlay;
	// Play the desired item fanfare
	audio_play_sound(global.itemTheme, 1, false);
	// Stuff for the item collection screen
	global.itemName = itemName;
	global.itemDescription = itemDescription;
}

// Hide the item if it's behind a block
if(place_meeting(x, y, par_block))
	visible = false;
else
	visible = true;