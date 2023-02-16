entity_draw();

// 
if (flagID == EVENT_FLAG_INVALID) {return;}
draw_sprite_ext(spr_missile_lock, 0, x, y, image_xscale, image_yscale, 0, c_white, 1 - (imageIndex / spriteLength));