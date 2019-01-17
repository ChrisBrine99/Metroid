/// @description Draws a scanline effect to the screen.
/// @param alpha

var alpha;
alpha = argument0;

for (var i = 0; i < global.camHeight; i++){
	// Draws the scanline on every other line of pixels.
	if (i % 2 == 0){
		draw_sprite_ext(spr_scanline, 0, global.camX, global.camY + i, 1, 1, 0, c_white, alpha);
	}
}