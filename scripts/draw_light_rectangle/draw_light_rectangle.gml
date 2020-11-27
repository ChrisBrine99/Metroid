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