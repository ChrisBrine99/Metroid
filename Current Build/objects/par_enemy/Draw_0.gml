/// @description Insert description here
// You can write your code in this editor

draw_self();
// Draw a red overlay to indicate when the enemy has been hit
if (hit && hitpoints > -255) draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, direction, 255, 0.5);	