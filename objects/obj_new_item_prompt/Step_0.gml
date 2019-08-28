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
		fadingIn = false;
		isClosing = true;
	} else{ // Display the whole block of text if it isn't being displayed already
		curDisplayedStr = displayTxt;
	}
}

#endregion

#region Fading the text in and out

scr_alpha_control_update();

fadingIn = !isClosing;
if (isClosing){ // Delete the creator object
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