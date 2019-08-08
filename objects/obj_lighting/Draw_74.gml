/// @description Drawing and Displaying the Lighting System
// You can write your code in this editor

#region Ensuring the lighting surface exists before drawing

if (!surface_exists(global.lighting)){
	global.lighting = surface_create(surfWidth, surfHeight);
}

#endregion

#region Drawing to the lighting surface

surface_set_target(global.lighting);

// Drawing the darkened rectangle that the light sources will be placecd on
draw_set_color(curLightingCol); // The lighter the color, the darker the surface
draw_rectangle(0, 0, surfWidth, surfHeight, false);

// Setting the blend mode to subtract to create the spotlight lighting system
gpu_set_blendmode(bm_subtract);

// Looping through all of the current active light sources
if (!ds_list_empty(global.lightSources)){
	var length, scaleAmount;
	length = ds_list_size(global.lightSources);
	scaleAmount = scale;
	numDrawn = 0;
	for (var i = 0; i < length; i++){
		// Draw a light to the surface for every light that is currently active
		var curLight = ds_list_find_value(global.lightSources, i);
		with(curLight){
			// If the light is disabled, don't bother checking if it is on screen
			if (canDraw){
				var leftSide, rightSide, topSide, botSide;
				// Find out what type of light needs to be drawn
				switch(lightType){
					case LIGHT.CIRCLE: // Draws a spotlight style light
						// Only draw the light if it is visible on screen
						if (x >= global.camX - xRad && y >= global.camY - yRad && x <= global.camX + global.camWidth + xRad && y <= global.camY + global.camHeight + yRad){
							leftSide = (x - xRad - global.camX) * scaleAmount;
							rightSide = (x + xRad - global.camX) * scaleAmount;
							topSide = (y - yRad - global.camY) * scaleAmount;
							botSide = (y + yRad - global.camY) * scaleAmount;
							draw_ellipse_color(leftSide, topSide, rightSide, botSide, lightCol, c_black, false);
							other.numDrawn++;
						}
						break;
					case LIGHT.RECT_FADE: // Draws a rectangle that fades upward
						// Only draw the light if it is visible on screen
						if (x >= global.camX - xRad && y >= global.camY - yRad && x <= global.camX + global.camWidth && y < global.camY + global.camHeight){
							leftSide = (x - global.camX) * scaleAmount;
							rightSide = xRad  * scaleAmount;
							topSide = (y - global.camY) * scaleAmount;
							botSide = yRad * scaleAmount;
							draw_rectangle_color(leftSide, topSide, leftSide + rightSide, topSide + botSide, c_black, c_black, lightCol, lightCol, false);
							if (subLightHeight > 0){
								draw_set_color(lightCol);
								draw_rectangle(leftSide, topSide + botSide, leftSide + rightSide, topSide + botSide + (subLightHeight * scaleAmount), false);
							}
							other.numDrawn++;
						}
						break;
				}
			}
		}
	}
}

// Drawing a nice lower gradient rectangle if the need arises
if (drawRectangle){
	draw_rectangle_color(xPos * scale, yPos * scale, (xPos + width) * scale, (yPos + height) * scale, oRectCol, oRectCol, rectCol, rectCol, false);
}

// Reset drawing back to the application
surface_reset_target();

#endregion

#region Displaying to the Screen

// Drawing the completed surface to the screen
draw_surface_stretched(global.lighting, 0, 0, global.camWidth, global.camHeight);
// Returning the blend mode back to normal
gpu_set_blendmode(bm_normal);

#endregion