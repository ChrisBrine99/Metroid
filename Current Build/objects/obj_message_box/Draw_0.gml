/// @description Insert description here
// You can write your code in this editor

draw_set_alpha(alpha);
draw_set_color(c_black);
draw_rectangle(xOffset - 61, yOffset - 23, xOffset + 61, yOffset + 23, false);
draw_rect(alpha * 0.15, alpha, c_blue, c_black, true, xOffset - 60, yOffset - 22, 120, 44);

event_inherited();

draw_set_halign(fa_center);
draw_text_outline(xOffset, yOffset - 17, strPrompt, c_white, c_black);
draw_set_halign(fa_left);

draw_set_alpha(1);