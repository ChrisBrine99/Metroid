/// @description Updates the camera position
// You can write your code in this editor

// Setting the size of the display window
var viewX, viewY;
viewX = global.camWidth * global.xScale;
viewY = global.camHeight * global.yScale;
window_set_size(viewX, viewY);
surface_resize(application_surface, viewX, viewY);

if (keyboard_check_pressed(vk_space)){
	global.oVideo[1] = !global.oVideo[1];
	alarm[1] = 1;
}

// Only move the camera based on the object it is following when the camera isn't shaking
if (isLocked){
	if (curObject != self){
		x += ((round(curObject.x) - x) / camSpd) * global.deltaTime;
		y += ((round(curObject.y) - y) / camSpd) * global.deltaTime;
	}
	// Setting camera bounds
	scr_camera_bounds(0, 0, room_width, room_height);
}

// Getting the x and y position of the camera
global.camX = x - (global.camWidth / 2);
global.camY = y - (global.camHeight / 2);

// Deactivating objects outside of the camera's view
instance_deactivate_object(obj_culled_object);
instance_activate_region(global.camX - 48, global.camY - 48, global.camX + global.camWidth + 48, global.camY + global.camHeight + 48, true);

// Resetting the view matrix
var vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);

// Exiting the Game (For Debugging)
if (keyboard_check(vk_f12) && keyboard_check(vk_f1)){
	game_end();
}
// Freezing the Game (For Debugging)
if (keyboard_check_pressed(vk_f2)){
	if (global.gameState == GAME_STATE.IN_GAME){
		global.gameState = GAME_STATE.PAUSED;
		with(obj_camera) {curObject = self;}
	} else{
		global.gameState = GAME_STATE.IN_GAME;
		with(obj_camera) {curObject = obj_player;}
	}
}