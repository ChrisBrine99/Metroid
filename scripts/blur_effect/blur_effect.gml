/// @description Holds all the code for processing a two-step blur shader effect. The first pass is a horizontal
/// blur, (Although, order doesn't matter) and that result is stored into the buffer surface. The second pass
/// takes that buffer and draws it to the application surface with a vertical blur applied.
/// @param blurSteps
/// @param sigma

function blur_effect(_blurSteps, _sigma) {
	// Begin drawing using the blur shader's 2-pass system
	shader_set(blurShader);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sBlurSteps, _blurSteps);
	shader_set_uniform_f(sTexelSize, 1 / WINDOW_WIDTH, 1 / WINDOW_HEIGHT);
	shader_set_uniform_f(sSigma, _sigma);

	// The first pass: horizontal blurring
	shader_set_uniform_f(sBlurVector, 1, 0); // [1, 0] tells the shader to blur horizontally
	surface_set_target(auxSurfaceA);
	draw_surface(resultSurface, 0, 0);
	surface_reset_target();

	// The second pass: vertical blurring
	shader_set_uniform_f(sBlurVector, 0, 1); // [0, 1] tells the shader to blur vertically
	surface_set_target(resultSurface);
	draw_surface(auxSurfaceA, 0, 0);
	surface_reset_target();

	shader_reset();
}