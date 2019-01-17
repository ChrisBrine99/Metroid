/// @description Insert description here
// You can write your code in this editor

var tempXTo;
tempXTo = xTo - (global.camWidth / 2);

if (!rightLock){ // Unlocking the camera to the left
	if (obj_samus.x <= tempXTo + buffer || obj_samus.x >= tempXTo + buffer + (global.camWidth / 2)){
		obj_camera.xTo = obj_samus.x;
		return;
	}
}
else{ // Unlocking the camera to the right
	if (obj_samus.x >= tempXTo + buffer || obj_samus.x <= tempXTo + buffer - (global.camWidth / 2)){
		obj_camera.xTo = obj_samus.x;
		return;
	}
}

// Lock the camera onto a set position
obj_camera.xTo = xTo;