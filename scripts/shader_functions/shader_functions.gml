/// @description This file contains all the data needed by the effect handler object to properly display shader
/// effects that are used in the game. These include blurring the image, the lighting system, a subtle bloom
/// effect, some chromatic aberration, a sccanline effect, and so on.
///
/// NOTE -- The order to apply these shaders is VERY IMPORTANT
///				1	--	Lighting System
///				2	--	Bloom Effect
///				3	--	Chromatic Aberration Effect
///				4	--	Heat Haze Effect
///				5	--	Blur Effect
///				6	--	Scanline Effect
///

/// @description Holds all the code for processing the simple lighting shader. First it goes through all existing
/// and visible light sources in the room and draws them to a surface. After that, the shader effect is applied
/// with the light surface; resulting in the final result output onto the screen.
/// @param [r/g/b]
/// @param brightness
/// @param contrast
/// @param saturation
function lighting_system(_lightColor, _brightness, _contrast, _saturation){
	// Begin by drawing all the light sources onto a texture
	surface_set_target(auxSurfaceA);

	// Completely black out the lighting surface before drawing the lights to it
	draw_clear(c_black);
	gpu_set_blendmode(bm_add);
	gpu_set_tex_filter(true);

	// Store the top-left coordinate of the camera for easy reuse
	var _cameraX, _cameraY;
	_cameraX = global.controllerID.x - (WINDOW_WIDTH / 2);
	_cameraY = global.controllerID.y - (WINDOW_HEIGHT / 2);
	with(obj_light){ // Display every visible light instance onto the light surface
		script_execute(drawFunction, _cameraX, _cameraY);
	}

	// Finally, reset the GPU and surface target
	gpu_set_tex_filter(false);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();

	// After adding all the lights to their surface, render the lighting system with its shader
	shader_set(lightShader);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f_array(sColor, _lightColor);
	shader_set_uniform_f(sBrightness, _brightness);
	shader_set_uniform_f(sContrast, _contrast);
	shader_set_uniform_f(sSaturation, _saturation);
	texture_set_stage(sLightTexture, auxTextureA);

	surface_set_target(resultSurface);
	draw_surface(application_surface, 0, 0);
	surface_reset_target();

	shader_reset();
}

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