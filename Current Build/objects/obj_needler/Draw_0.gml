/// @description Insert description here
// You can write your code in this editor

var yOffset, dir;
yOffset = 8;
dir = direction;
if (object_get_name(object_index) == "obj_needler"){
	yOffset = 0;
	dir = 0;
}
draw_sprite_ext(spr, image_index, x, y + yOffset, image_xscale, image_yscale, dir, c_white, 1);	
// Draw a red overlay to indicate when the enemy has been hit
if (hit) draw_sprite_ext(spr, image_index, x, y + yOffset, image_xscale, image_yscale, dir, 255, 0.5);	