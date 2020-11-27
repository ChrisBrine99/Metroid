/// @description Holds all the code for processing the bloom effect for the game. This makes bright areas appear
/// brighter on the screen, with a semi-transparent glow around them relative to the strength of the bloom effect.
/// @param bloomThreshold
/// @param bloomRange
/// @param blurSteps
/// @param sigma
/// @param bloomIntensity
/// @param bloomDarken
/// @param bloomSaturation

function bloom_effect(_bloomThreshold, _bloomRange, _blurSteps, _sigma, _bloomIntensity, _bloomDarken, _bloomSaturation){
	// Before processing anything, copy over the resultSurface to auxSurfaceA
	surface_copy(auxSurfaceB, 0, 0, resultSurface);

	// First pass: Draw bright areas to resultSurface
	shader_set(bloomShaderLuminence);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sBloomThreshold, _bloomThreshold);
	shader_set_uniform_f(sBloomRange, _bloomRange);

	surface_set_target(resultSurface);
	draw_surface(auxSurfaceB, 0, 0);
	surface_reset_target();

	shader_reset();

	// Second pass: Blur bright areas to auxSurfaceB
	blur_effect(_blurSteps, _sigma);

	// Third pass: Blend the blurred surface with the stored result surface
	shader_set(bloomShaderBlend);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sBloomIntensity, _bloomIntensity);
	shader_set_uniform_f(sBloomDarken, _bloomDarken);
	shader_set_uniform_f(sBloomSaturation, _bloomSaturation);
	texture_set_stage(sBloomTexture, resultTexture);
	gpu_set_tex_filter_ext(sBloomTexture, true); // Linear filter for bloom surface for smoother looking bloom

	surface_set_target(auxSurfaceA);
	draw_surface(auxSurfaceB, 0, 0);
	surface_reset_target();

	shader_reset();

	// Finally, copy to the surface that gets rendered after all post-processing effects
	surface_copy(resultSurface, 0, 0, auxSurfaceA);
}