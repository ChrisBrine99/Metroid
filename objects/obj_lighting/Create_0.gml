/// @description Creating the variable to hold the lighting system
// You can write your code in this editor

global.lighting = surface_create(global.camWidth, global.camHeight);
// The current colors of the lighting system
global.curLightingCol = c_gray;

// The ds_list to hold every light source in the current room
global.lightSources = ds_list_create();
numDrawn = 0;