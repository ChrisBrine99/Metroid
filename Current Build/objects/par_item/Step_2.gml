/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting) && !hidden){
	var radius;
	radius = 18;
	// Draw the light
	scr_draw_light(x + (sprite_width / 2), y + (sprite_height / 2), radius, radius, color);
}