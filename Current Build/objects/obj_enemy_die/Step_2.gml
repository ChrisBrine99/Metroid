/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	var radius, color;
	color = c_yellow;
	radius = 40 + (image_index * 5);
	scr_draw_light(x, y, radius, radius, color);
}