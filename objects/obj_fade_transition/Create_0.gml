/// @description Initializing Default Variables
// You can write your code in this editor

// Don't allow the Fade Transition to do its thing if the game is paused
if (global.gameState == GAME_STATE.PAUSED){
	instance_destroy(self);
	return;
}

alpha = 0;				// The alpha channel for the fade
alphaIncr = 0.1;		// How fast the alpha increases and decreases
opaqueTime = 60;		// Time in frames that the fade is opaque for
fadingIn = true;		// If false, the effect should be fading away
rectCol = c_black;		// The color of the fade-in rectangle
effectID = noone;		// The instance ID of the Sprite Sweep effect

// Freezing the game when the user isn't in the menu
global.gameState = GAME_STATE.PAUSED;