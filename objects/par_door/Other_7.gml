/// @description Destroy the Door, Unlock if Required
// You can write your code in this editor

if (!open){
	if (index >= 0) {global.door[index] = true;}
	instance_destroy(self);
}