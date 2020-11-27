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