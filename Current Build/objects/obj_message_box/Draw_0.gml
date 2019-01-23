/// @description Insert description here
// You can write your code in this editor

draw_set_font(font_gui_small);

var halfWidth, halfHeight;
halfWidth = string_width(strPrompt) / 2;
halfHeight = (string_height(strPrompt) + (textGap * 2) + 4) / 2;

draw_set_alpha(alpha);
draw_set_color(c_black);
draw_rectangle(floor(xOffset - halfWidth - 3), yOffset - halfHeight - 1, floor(xOffset + halfWidth + 3), yOffset + halfHeight + 1, false);
draw_rect(alpha * 0.15, alpha, c_blue, c_black, true, floor(xOffset - halfWidth - 2), yOffset - halfHeight, floor(halfWidth * 2 + 4), halfHeight * 2 + 2);

event_inherited();

draw_set_halign(fa_center);
draw_text_outline(xOffset + 1, yOffset - halfHeight + 2, strPrompt, c_white, c_black);
draw_set_halign(fa_left);

draw_set_alpha(1);