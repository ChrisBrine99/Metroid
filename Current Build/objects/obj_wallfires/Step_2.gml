/// @description Insert description here
// You can write your code in this editor

if (offset == 120)
	return;

if (instance_exists(obj_lighting)){
	var radius, color;
	scr_draw_light(x + (sprite_width / 2) - 2, y - 2, 12, 12, c_red);
	if (cooldownTimer <= 45 && numFired >= 3)
		scr_draw_light(x + (sprite_width / 2), y - 4, 6 + (4 * image_index), 6 + (4 * image_index), c_lime);	
}