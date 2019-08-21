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
// The higher the value, the slower the camera moves toward it's current object
camSpd = 4;

// Set up the video settings
alarm[1] = 1;

// If false, the camera will temporarily be unlocked from following the player because of an effect (Ex. screen shaking)
isLocked = true;