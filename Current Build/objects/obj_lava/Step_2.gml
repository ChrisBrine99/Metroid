/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	var radiusX, radiusY, color;
	radiusX = (16 * image_xscale) + 40;
	radiusY = (16 * image_yscale) + 80;
	color = c_orange;
	scr_draw_light(x + ((image_xscale * 16) / 2), y + ((image_yscale * 16) / 2), radiusX, radiusY, color);
}