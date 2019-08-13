/// @description Initializing Default Variables
// You can write your code in this editor

// Call the parent's create event
event_inherited();
fadingIn = true;

// Don't allow the Fade Transition to do its thing if the game is paused
if (global.gameState == GAME_STATE.PAUSED){
	instance_destroy(self);
	return;
}

opaqueTime = 60;		// Time in frames that the fade is opaque for
rectCol = c_black;		// The color of the fade-in rectangle
effectID = noone;		// The instance ID of the Sprite Sweep effect

// Freezing the game when the user isn't in the menu
global.gameState = GAME_STATE.PAUSED;
with(obj_hud) {isVisible = false;}