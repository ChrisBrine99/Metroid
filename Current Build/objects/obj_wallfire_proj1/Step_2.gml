/// @description Insert description here
// You can write your code in this editor

// Draw a light around the projectile
if (instance_exists(obj_lighting)){
	scr_draw_light(x, y, 12, 12, c_blue);
}