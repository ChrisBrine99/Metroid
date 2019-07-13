/// @description Creates the camera
// You can write your code in this editor

// Enabling the view
view_enabled = true;
view_set_visible(0, true);

// Setting the resolution and the scaling factor
global.camWidth = 320;
global.camHeight = 180;

// Variables to hold the position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

// Creating the camera
camera = camera_create();

// Creating a projection matrix for the camera
var vm, pm;
vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
pm = matrix_build_projection_ortho(global.camWidth, global.camHeight, 1, 10000);
// Setting the camera's view matrix and projection matrix
camera_set_view_mat(camera, vm);
camera_set_proj_mat(camera, pm);
// Setting the current view to the camera
view_camera[0] = camera;

// Setting what object the camera is going to follow
curObject = self;
if (instance_exists(obj_player)){
	// Locking the camera onto the player object
	alarm[0] = 1;
	curObject = obj_player;
}
xTo = x;
yTo = y;

// TEMPORARY CODE ///////////////////////////////////////////////////

global.xScale = floor(display_get_width() / global.camWidth);
global.yScale = floor(display_get_height() / global.camHeight);

display_set_gui_maximize(global.xScale, global.yScale, 0, 0);
window_set_fullscreen(true);

/////////////////////////////////////////////////////////////////////

// If false, the camera will temporarily be unlocked from following the player because of an effect (Ex. screen shaking)
isLocked = true;

// The opacity of the various HUD elements (Of which there are very few)
alpha = 0;
isVisible = false;

// Variable to control the noise filter's speed
image_speed = 0.25;