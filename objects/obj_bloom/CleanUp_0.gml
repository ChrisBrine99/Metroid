/// @description Cleaning up shader stuff
// You can write your code in this editor

if (global.bloomID == id){
	global.bloomID = noone;
	// Free the surfaces
	if (surface_exists(surfBlur)) {surface_free(surfBlur);}
	if (surface_exists(surfBloom)) {surface_free(surfBloom);}
	// Begin automatically drawing the application surface again
	application_surface_draw_enable(true);
}