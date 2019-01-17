/// @description Insert description here
// You can write your code in this editor

// Draw a black background for the pause screen
draw_set_alpha(alpha * 0.3);
draw_set_color(c_black);
draw_rectangle(global.camX, global.camY, global.camX + global.camWidth, global.camY + global.camHeight, false);
draw_set_alpha(alpha);

// Center the text
draw_set_halign(fa_center);
// Call the parent's draw event
event_inherited();

// Return the text to the correct alignment
draw_set_halign(fa_left);
draw_set_alpha(1);