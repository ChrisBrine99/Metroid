/// @description Draws a light circle around a given object. Can have its color and size adjusted.
/// @param originX
/// @param originY
/// @param radiusX
/// @param radiusY
/// @param color

var originX, originY, radiusX, radiusY, color;
originX = argument0;
originY = argument1;
radiusX = argument2;
radiusY = argument3;
color = argument4;

// Stop trying to draw to the surface if it doesn't currently exist
if (!surface_exists(global.lighting)){
	return;	
}

// Drawing the circle to the global lighting surface
gpu_set_blendmode(bm_subtract);
surface_set_target(global.lighting);
draw_ellipse_color(originX - radiusX - global.camX, originY - radiusY - global.camY, originX + radiusX - global.camX, originY + radiusY - global.camY, color, c_black, false);
surface_reset_target();
gpu_set_blendmode(bm_normal);

// NOTE: Make sure to surround any calling of this script with:
//				if (instance_exists(obj_lighting)){
//						// Call script here //
//				}
// Otherwise, the program will crash when attempting to draw a circle to the surface if the surface hasn't
// been created. Eg. if obj_lighting hasn't been created yet.