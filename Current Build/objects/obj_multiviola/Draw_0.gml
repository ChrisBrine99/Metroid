/// @description Insert description here

// You can write your code in this editor
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, -imgDir, c_white, 1);	
// Draw a red overlay to indicate when the enemy has been hit
if (hit) draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, -imgDir, 255, 0.5);	