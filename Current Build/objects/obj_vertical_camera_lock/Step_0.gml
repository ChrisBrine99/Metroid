/// @description Insert description here
// You can write your code in this editor

var tempYTo;
tempYTo = yTo - (global.camHeight / 2);

if (!upwardLock){ // Unlocking the camera from going down
	if (obj_samus.y >= tempYTo + buffer || obj_samus.y <= tempYTo + buffer - (global.camHeight / 2)){
		obj_camera.yTo = obj_samus.y;
		return;
	}
}
else{ // Unlocking the camera from going up
	if (obj_samus.y <= tempYTo + buffer || obj_samus.y >= tempYTo + buffer + (global.camHeight / 2)){
		obj_camera.yTo = obj_samus.y;
		return;
	}
}

// Lock the camera onto a set position
obj_camera.yTo = yTo;