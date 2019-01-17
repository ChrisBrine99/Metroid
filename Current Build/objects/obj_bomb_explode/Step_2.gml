/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	var radius, color;
	radius = sprite_width + (image_index * 5);
	color = choose(c_white, c_aqua);
	scr_draw_light(x, y, radius, radius, color);
}