/// @description Holds the code responsible for creating the wavy heat haze effect on the screen. The wave is
/// caused by a texture (spr_heat_haze) being sampled from different points relative to a timer variable.
/// @param hazeSize
/// @param hazeStrength
/// @param hazeSpeed

function heat_haze_effect(_hazeSize, _hazeStrength, _hazeSpeed) {
	shader_set(heatHazeShader);
	// Set the uniforms to their corresponding values
	shader_set_uniform_f(sHazeTime, time);
	shader_set_uniform_f(sHazeSize, _hazeSize);
	shader_set_uniform_f(sHazeStrength, _hazeStrength);
	texture_set_stage(sHazeTexture, hazeTexture);

	// Draw the aberration effect to the result surface
	surface_set_target(resultSurface);
	gpu_set_tex_filter(true); // Without a linear filter this shader looks like garbage

	draw_surface(auxSurfaceA, 0, 0);

	gpu_set_tex_filter(false);
	surface_reset_target();

	shader_reset();

	// Increment the shader's time value
	time += global.deltaTime * _hazeSpeed;
}