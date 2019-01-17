/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	gpu_set_blendmode(bm_subtract);
	surface_set_target(global.lighting);
	surface_reset_target();
	gpu_set_blendmode(bm_normal);
}