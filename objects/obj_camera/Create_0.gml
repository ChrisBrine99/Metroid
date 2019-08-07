/// @description Creates the camera
// You can write your code in this editor

// Setting the resolution and the scaling factor
global.camWidth = 320;
global.camHeight = 180;

// Variables to hold the position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

// Creating the camera
camera = camera_create();

// Setting up the Camera
alarm[2] = 1;

// Setting what object the camera is going to follow
curObject = self;
if (instance_exists(obj_player)){
	// Locking the camera onto the player object
	alarm[0] = 1;
	curObject = obj_player;
}
camSpd = 2;

// TEMPORARY CODE ///////////////////////////////////////////////////

global.xScale = floor(display_get_width() / global.camWidth);
global.yScale = floor(display_get_height() / global.camHeight);

display_set_gui_maximize(global.xScale, global.yScale, 0, 0);
window_set_fullscreen(true);

/////////////////////////////////////////////////////////////////////

// If false, the camera will temporarily be unlocked from following the player because of an effect (Ex. screen shaking)
isLocked = true;