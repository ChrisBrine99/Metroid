/// @description Insert description here
// You can write your code in this editor

// Drawing the regular sprite
draw_sprite_ext(spr_tsumuri0, image_index, x, y + 8, image_xscale, image_yscale, direction, c_white, 1);

// Draw a red overlay to indicate when the enemy has been hit
if (hit) draw_sprite_ext(spr_tsumuri0, image_index, x, y + 8, image_xscale, image_yscale, direction, 255, 0.5);	