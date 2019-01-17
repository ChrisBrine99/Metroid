/// @description Draw the game over screen
// You can write your code in this editor

// Draw a red background for the game over screen
draw_rect(0.3, 1, c_maroon, c_black, true, 0, 0, global.camWidth, global.camHeight);

// Center the text
draw_set_halign(fa_center);
// Call the parent's draw event
event_inherited();

draw_set_font(font_gui_large);
draw_text_outline(global.camWidth / 2, 40, "GAME OVER", c_maroon, c_black);

// Return the text to the correct alignment
draw_set_halign(fa_left);