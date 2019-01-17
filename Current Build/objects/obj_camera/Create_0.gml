/// @description Creates the camera
// You can write your code in this editor

// The width and height of the game window
global.camWidth = 320;
global.camHeight = 172;
// How scaled up the game window will get
scale = 4;

// Creating the actual camera
camera = camera_create();

var vm, pm;
vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
pm = matrix_build_projection_ortho(global.camWidth, global.camHeight, 1, 10000);

camera_set_view_mat(camera, vm);
camera_set_proj_mat(camera, pm);

view_camera[0] = camera;

// Lets the camera have a nice shaking effect
global.followPlayer = true;

// Variables to hold the position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

curObject = self;
if (instance_exists(obj_samus))
	curObject = obj_samus;
xTo = x;
yTo = y;

alarm[0] = 1;