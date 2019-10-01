/// @description Initializing Default Variables
// You can write your code in this editor

// Enable this object to use the alpha control scripts
scr_alpha_control_create();
fadingIn = true;

opaqueTime = 60;		// Time in frames that the fade is opaque for
rectCol = c_black;		// The color of the fade-in rectangle
effectID = noone;		// The instance ID of the Sprite Sweep effect

// Freezing the game when the user isn't in the menu (AKA the player exists)
if (instance_exists(obj_player)){
	global.gameState = GAME_STATE.PAUSED;
	with(obj_hud) {isVisible = false;}
}