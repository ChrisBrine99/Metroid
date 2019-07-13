/// @description Create the explosion effect
// You can write your code in this editor

if (destroyFX && FXobj != noone){
	instance_create_depth(x, y, depth - 100, FXobj);
}