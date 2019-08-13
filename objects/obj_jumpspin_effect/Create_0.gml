/// @description Setting up the effect
// You can write your code in this editor

// Unique Variables for this Effect
imgToDraw = obj_player.sprite_index;
imgIndex = obj_player.image_index;	
imgXScale = obj_player.image_xscale;
imgYScale = obj_player.image_yscale;

// Call the parent's Create Event
event_inherited();

// Tell the animation controller to fade out
alpha = 0.5;
fadingIn = false;
freezeOnPause = true;

// Stop the "Animation End" Event from Triggering
image_speed = 0;