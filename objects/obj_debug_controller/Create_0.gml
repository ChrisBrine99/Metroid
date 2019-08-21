/// @description Insert description here
// You can write your code in this editor

// Enable this object to use the alpha control scripts
scr_alpha_control_create();
// Make the Debug controller destroy itself upon fading away
destroyOnZero = true;
fadeDestroy = false;

// Display Game Maker's built-in debug information
show_debug_overlay(true);

// Updating information on the debug menu every second
alarm[0] = 1;
// The default values for each variable
var defaultVal = string("0");
numInstances = defaultVal;
numActiveObjects = defaultVal;
numEntities = defaultVal;
numActiveEntities = defaultVal;
numDrawnEntities = defaultVal;
numLightSources = defaultVal;
numDrawnLights = defaultVal;