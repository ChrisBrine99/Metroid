/// @description Setting the GUI display scaling
// You can write your code in this editor

display_reset(0, global.oVideo[2]);

global.xScale = floor(display_get_width() / global.camWidth);
global.yScale = floor(display_get_height() / global.camHeight);
// Fix the scaling if the game isn't in fullscreen mode
if (!global.oVideo[1]){
	global.xScale = global.oVideo[0];
	global.yScale = global.oVideo[0];
}

// Set the window to Fullscreen
window_set_fullscreen(global.oVideo[1]);
// Set the offset of the window (If one exists)
global.xOffset = 0;
global.yOffset = 0;
// Calculate the xOffset and yOffset of the display
if (global.oVideo[1]){
	global.xOffset = round((display_get_width() - (global.camWidth * global.xScale)) / 2);
	global.yOffset = round((display_get_height() - (global.camHeight * global.yScale)) / 2);
}

// Scale the GUI to the display scale and offset
display_set_gui_maximize(global.xScale, global.yScale, global.xOffset, global.yOffset);