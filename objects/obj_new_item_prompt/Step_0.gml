/// @description Menu Control
// You can write your code in this editor

#region Keyboard Input(s)

// The keyboard input variable
var keyClose = keyboard_check_pressed(ord("Z"));

#endregion

#region Altering the Game State

// Freeze the game whilst this prompt is on-screen
global.gameState = GAME_STATE.PAUSED;

#endregion

#region Controlling the menu from user input

if (keyClose){
	if (curDisplayedStr == displayTxt){ // Close the menu (Only if the full block of text is being displayed)
		isClosing = true;
	} else{ // Display the whole block of text if it isn't being displayed already
		curDisplayedStr = displayTxt;
	}
}

#endregion

#region Fading the text in and out

if (!isClosing){ // Making the text fade in
	if (alpha < 1){
		alpha += 0.1;
	}
} else{ // Making the text fade out and destroying this object
	if (alpha > 0){
		alpha -= 0.1;	
	} else{
		instance_destroy(self);
		// Make the HUD visible again and unfreeze the camera
		with(obj_hud) {isVisible = true;}
		with(obj_camera) {camSpd = 1;}
		// Return the Game State back to normal
		global.gameState = GAME_STATE.IN_GAME;
		// Destroy the background blur
		if (blurID != noone){
			instance_destroy(blurID);
			blurID = noone;	
		}
		// Resume all audio that was playing before the player picked up the item
		if (audio_is_playing(fanfare)) {audio_stop_sound(fanfare);}
		audio_resume_all();
	}
	// Delete the creator object
	if (creatorID != noone){
		instance_destroy(creatorID);
		creatorID = noone;
	}
}
// Make the blur have a gradual fading in and out along with the menu
if (blurID != noone){
	blurID.sigma = alpha * 0.25;
}

#endregion