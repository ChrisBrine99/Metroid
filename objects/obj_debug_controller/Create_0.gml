/// @description Insert description here
// You can write your code in this editor

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
numLightSources = defaultVal;
numDrawnLights = defaultVal;

// The alpha level for the debug menu
alpha = 0;
fadeDestroy = false;

// Variable to check if all Items is enabled
allItems = false;