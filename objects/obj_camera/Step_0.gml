/// @description Updates the camera position
// You can write your code in this editor

// Setting the size of the display window
var viewX, viewY;
viewX = global.camWidth * global.xScale;
viewY = global.camHeight * global.yScale;
window_set_size(viewX, viewY);
surface_resize(application_surface, viewX, viewY);

// Only move the camera based on the object it is following when the camera isn't shaking
if (isLocked){
	if (curObject != self){
		// Move the camera toward where it needs to go
		x += ((xTo - x) / 5) * camSpd;
		y += ((yTo - y) / 5) * camSpd;
		// Update the next goto position for the camera
		xTo = curObject.x;
		yTo = curObject.y;
	}
}
// Setting camera bounds
scr_camera_bounds(0, 0, room_width, room_height);

// Getting the x and y position of the camera
global.camX = obj_camera.x - (global.camWidth / 2);
global.camY = obj_camera.y - (global.camHeight / 2);

// Deactivating objects outside of the camera's view
instance_deactivate_object(obj_culled_object);
instance_activate_region(x - (global.camWidth / 2) - 16, y - (global.camHeight / 2) - 16, x + (global.camWidth / 2) + 32, y + (global.camHeight / 2) + 32, true);

// Resetting the view matrix
var vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);

// Exiting the Game (For Debugging)
if (keyboard_check(vk_f12) && keyboard_check(vk_f1)){
	game_end();
}