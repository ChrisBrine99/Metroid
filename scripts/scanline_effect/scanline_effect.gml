/// @description Holds the code that handles the scanline shader on the GUI surface. It's a very simple shader 
/// that applies a black line to each even pixel relative to the height. The strength of the effect determines
/// how pronounced the scanlines are.
/// @param viewHeight
/// @param strength

function scanline_effect(_viewHeight, _strength){
	shader_set(scanlineShader);
	// Set the uniforms to their corresponding values.
	shader_set_uniform_f(sViewHeight, _viewHeight);
	shader_set_uniform_f(sStrength, _strength);

	// Draw the surface to the screen; applying the shader's effect to it
	draw_surface(resultSurface, 0, 0);

	shader_reset();
}