/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_samus)){
	if (doorFade){
		obj_samus.visible = true;
		obj_samus.canMove = true;
	}
	global.isPaused = false;
}