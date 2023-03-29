entity_draw();

// Display the power bomb lock above the door if it hasn't been unlocked yet. Otherwise, the door will draw
// itself like a standard blue door; being opened as if it were one as well.
if (flagID == EVENT_FLAG_INVALID) {return;}
draw_sprite_ext(spr_power_bomb_lock, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 1 - (imageIndex / spriteLength));