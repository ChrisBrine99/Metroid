/// @description Destroy the Camera
// You can write your code in this editor

if (global.cameraID == id){
	global.cameraID = noone;
	camera_destroy(camera);
}