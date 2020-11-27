/// @description Functions that are used to draw a light source relative to the light it was created as. For
/// now, it only contains ways for displaying circular and rectangular light sources, but anything is possible
/// within the constraints of Game Maker.

/// @description Draws a circular light to the screen for use in the lighting system. Nothing will be drawn if it
/// is outside of the current camera view.
/// @param cameraX
/// @param cameraY
function draw_light_circle(_cameraX, _cameraY){
	if (x + size[X] < _cameraX || y + size[Y] < _cameraY || x - size[X] > _cameraX + WINDOW_WIDTH || y - size[Y] > _cameraY + WINDOW_HEIGHT){
		return; // The light is off of the screen; don't bother drawing the light
	}
	// Draw the light based on its radius, color, and strength
	draw_set_alpha(strength);
	draw_ellipse_color(x - size[X] - _cameraX, y - size[Y] - _cameraY, x + size[X] - _cameraX, y + size[Y] - _cameraY, colors[| 0], colors[| 1], false);
	draw_set_alpha(1);
}

/// @description Draws a rectanglular light source for use in the lighting system. If it is outside of the camera's
/// current view, it will not be drawn.
/// @param cameraX
/// @param cameraY
function draw_light_rectangle(_cameraX, _cameraY){
	if (x + size[X] < _cameraX || y + size[Y] < _cameraY || x > _cameraX + WINDOW_WIDTH || y > _cameraY + WINDOW_HEIGHT){
		return; // The light is off of the screen; don't bother drawing the light
	}
	// Draw the light based on its width, height, color, and strength
	draw_sprite_general(spr_rectangle, 0, 0, 0, 1, 1, x - _cameraX, y - _cameraY, size[X], size[Y], 0, colors[| 0], colors[| 1], colors[| 3], colors[| 2], strength);
}