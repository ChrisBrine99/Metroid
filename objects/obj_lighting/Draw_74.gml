/// @description Drawing the lighting system to the screen.
// You can write your code in this editor

#region Ensuring the lighting surface exists before drawing

if (!surface_exists(global.lighting)){
	global.lighting = surface_create(global.camWidth, global.camHeight);
}

#endregion

#region Drawing to the lighting surface

surface_set_target(global.lighting);

// Drawing the darkened rectangle that the light sources will be placecd on
draw_set_color(curLightingCol); // The lighter the color, the darker the surface
draw_rectangle(0, 0, global.camWidth, global.camHeight, false);

// Setting the blend mode to subtract to create the spotlight lighting system
gpu_set_blendmode(bm_subtract);

// Looping through all of the current active light sources
if (!ds_list_empty(global.lightSources)){
	var length;
	length = ds_list_size(global.lightSources);
	numDrawn = 0;
	for (var i = 0; i < length; i++){
		// Draw a light to the surface for every light that is currently active
		var curLight = ds_list_find_value(global.lightSources, i);
		with(curLight){
			// If the light is disabled, don't bother checking if it is on screen
			if (canDraw){
				// Only draw the light if it is visible on screen
				if (x > global.camX - xRad && y > global.camY - yRad && x < global.camX + global.camWidth + xRad && y < global.camY + global.camHeight + yRad){
					var leftSide, rightSide, topSide, botSide;
					leftSide = x - xRad - global.camX;
					rightSide = x + xRad - global.camX;
					topSide = y - yRad - global.camY;
					botSide = y + yRad - global.camY;
					draw_ellipse_color(leftSide, topSide, rightSide, botSide, lightCol, c_black, false);
					//draw_rectangle_color(leftSide, topSide, rightSide, botSide, c_black, c_black, lightCol, lightCol, false);
					other.numDrawn++;
				}
			}
		}
	}
}

// Drawing a nice lower gradient rectangle if the need arises
if (drawRectangle){
	draw_rectangle_color(xPos, yPos, xPos + width, yPos + height, oRectCol, oRectCol, rectCol, rectCol, false);
}

// Reset drawing back to the application
surface_reset_target();

#endregion

#region Display to the screen

// Drawing the completed surface to the screen
draw_surface(global.lighting, 0, 0);
// Returning the blend mode back to normal
gpu_set_blendmode(bm_normal);

#endregion