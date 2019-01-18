// The width and height of the game window
global.camWidth = 320;
global.camHeight = 172;

// Variables to hold the position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

instance_create_depth(320 / 2, 172 / 2, 0, obj_camera);
instance_create_depth(0, 0, 1, obj_title_menu);

//global.curSong = music_area1;
//global.offset = 9.098;