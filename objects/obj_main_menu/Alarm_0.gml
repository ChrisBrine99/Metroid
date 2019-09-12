/// @description Set background Speeds
// You can write your code in this editor

var starLayer;
starLayer = layer_get_id("Background");
layer_hspeed(starLayer, 0.003 * global.deltaTime);

starLayer = layer_get_id("Background2");
layer_hspeed(starLayer, 0.007 * global.deltaTime);
layer_background_xscale(starLayer, 2);
layer_background_yscale(starLayer, 2);

starLayer = layer_get_id("Background3");
layer_hspeed(starLayer, 0.015 * global.deltaTime);
layer_background_xscale(starLayer, 3);
layer_background_yscale(starLayer, 3);