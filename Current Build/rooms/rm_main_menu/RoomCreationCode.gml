// The width and height of the game window
global.camWidth = 320;
global.camHeight = 172;

// Variables to hold the position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

// Load in the player's options
if (file_exists("options"))
	scr_load_options("options");
else // Set the options to their default
	scr_default_options();

// Create the camera
instance_create_depth(global.camWidth / 2, global.camHeight / 2, 0, obj_camera);
// Create the title screen
instance_create_depth(0, 0, 1, obj_title_menu);

//global.curSong = music_area1;
//global.offset = 9.098;