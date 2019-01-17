/// @description Drawing the Title Screen
// You can write your code in this editor

// Draw a blue gradient for the title screen
draw_rect(0.15, 1, c_blue, c_black, true, 0, 0, global.camWidth, global.camHeight);

draw_set_alpha(alpha);
// Drawing the Title
draw_sprite(spr_title, 0, global.camWidth / 2, 15);


draw_set_font(font_gui_small);
// Center the text
draw_set_halign(fa_center);
// Drawing "Press Any Key" to the screen
draw_text_outline(global.camWidth / 2, global.camHeight - 35, "Press Any Key", c_white, c_black);
// Drawing the Copyright
draw_text_outline(global.camWidth / 2, global.camHeight - 10, "Nintendo -- 1986, 2018", c_white, c_black);
// Return the text to the correct alignment
draw_set_halign(fa_left);

// Reset the alpha value
draw_set_alpha(1);