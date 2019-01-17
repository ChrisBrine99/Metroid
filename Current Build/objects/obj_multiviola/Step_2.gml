/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	var radius, color;
	color = c_orange;
	radius = 20;
	scr_draw_light(x, y, radius, radius, color);
}