/// @description Destroy the Door
// You can write your code in this editor

if (type >= 5 && type < 8){
	global.spDoor[index] = true;
}

if (!closing){
	instance_destroy(self);
}