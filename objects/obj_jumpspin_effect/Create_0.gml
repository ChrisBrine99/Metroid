/// @description Setting up the effect
// You can write your code in this editor

// Unique Variables for this Effect
imgToDraw = obj_player.sprite_index;
imgIndex = obj_player.imgIndex;	
imgXScale = obj_player.imgXScale;
imgYScale = obj_player.imgYScale;

// Enable this object to use the alpha control scripts
scr_alpha_control_create();
// Tell the alpha controller to fade out
alpha = 0.5;
fadingIn = false;
freezeOnPause = true;
destroyOnZero = true;

// Checks if the second effect has spawned yet
hasSpawned = false;

// Stop the "Animation End" Event from Triggering
image_speed = 0;