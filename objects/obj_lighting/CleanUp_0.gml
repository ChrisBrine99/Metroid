/// @description Cleaning up Surface Stuff
// You can write your code in this editor

if (global.lightingID == id){
	global.lightingID = noone;
	if (surface_exists(global.lighting)) {surface_free(global.lighting);}
	ds_map_destroy(global.lightSources);
}