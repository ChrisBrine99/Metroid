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
		// Return the Game State back to normal
		global.gameState = GAME_STATE.IN_GAME;
	}
	// Delete the creator object
	if (creatorID != noone){
		instance_destroy(creatorID);
		creatorID = noone;
	}
}

#endregion