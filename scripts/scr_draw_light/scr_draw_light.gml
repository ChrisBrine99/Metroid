/// @description Draws a light around an object. The radius, position, and color of the light can be altered to
/// whatever the user chooses them to be. A downside of this lighting engine is it can only use circles.
/// @param xPos
/// @param yPos
/// @param xRad
/// @param yRad
/// @param lightCol

var xPos, yPos, xRad, yRad, lightCol;
xPos = argument0;
yPos = argument1;
xRad = argument2;
yRad = argument3;
lightCol = argument4;

// Stop trying to draw to the surface if it doesn't currently exist
//if (!surface_exists(global.lighting)){
//	return;	
//}

// Drawing the circle to the global lighting surface
gpu_set_blendmode(bm_subtract);
surface_set_target(global.lighting);
draw_ellipse_color(xPos - xRad - global.camX, yPos - yRad - global.camY, xPos + xRad - global.camX, yPos + yRad - global.camY, lightCol, c_black, false);
surface_reset_target();
gpu_set_blendmode(bm_normal);

// NOTE: Make sure to surround any calling of this script with:
//				if (instance_exists(obj_lighting)){
//						// Call script here //
//				}
// Otherwise, the program will crash when attempting to draw a circle to the surface because the surface hasn't
// been created.