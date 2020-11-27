/// @description Holds the code for processing the chromatic aberration shader effect. It's a simple shader
/// where colors get more distorted the further from the center the pixel is on the application surface.
/// @param aberration

function aberration_effect(_aberration){
	shader_set(abrerrationShader);
	// Set the uniform to its corresponding value.
	shader_set_uniform_f(sAberration, _aberration);

	// Draw the aberration effect to the first auxillary surface
	surface_set_target(auxSurfaceA);
	gpu_set_tex_filter(true); // Without a linear filter this shader looks like garbage

	draw_surface(resultSurface, 0, 0);

	gpu_set_tex_filter(false);
	surface_reset_target();

	shader_reset();

	// Finally, copy to the surface that gets rendered after all post-processing effects
	if (!isHazeEnabled){ // Don't copy to the result texture if the heat haze effect is enabled
		surface_copy(resultSurface, 0, 0, auxSurfaceA);
	}
}