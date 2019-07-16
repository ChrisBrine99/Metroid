/// @description Insert description here
// You can write your code in this editor

// Set the gui size to a 1:1 scale of the application surface
display_set_gui_maximize(1, 1, 0, 0);

// Create the blooming surface if it doesn't exist
if (!surface_exists(surfBloom)){
	surfBloom = surface_create(global.camWidth, global.camHeight);
	surface_resize(surfBloom, global.camWidth * global.xScale, global.camHeight * global.yScale);
	// Getting the bloom texture
	bloomTexture = surface_get_texture(surfBloom);
}
// Create the bluring surface if it doesn't exist
if (!surface_exists(surfBlur)){
	surfBlur = surface_create(global.camWidth, global.camHeight);
	surface_resize(surfBlur, global.camWidth * global.xScale, global.camHeight * global.yScale);
}
if (surface_exists(global.lighting)){
	appTexture = surface_get_texture(global.lighting);	
}

// 1st Pass: Draw brights to the bloom shader
// application_surface -> surfBloom
shader_set(shaderBloomLuminence);
shader_set_uniform_f(sBloomThreshold, bloomThreshold);
shader_set_uniform_f(sBloomRange, bloomRange);
texture_set_stage(sAppTexture, appTexture);

surface_set_target(surfBloom);
draw_surface(application_surface, 0, 0);
surface_reset_target();

// 2nd Pass: Blur the bloom shader horizontally.
// surfBloom -> surfBlur
gpu_set_tex_filter(true);

shader_set(shaderBlur);
shader_set_uniform_f(sBlurSteps, blurSteps);
shader_set_uniform_f(sSigma, sigma);
shader_set_uniform_f(sBlurVector, 1, 0);
shader_set_uniform_f(sTexelSize, 1 / global.camWidth, 1 / global.camHeight);

surface_set_target(surfBlur);
draw_surface(surfBloom, 0, 0);
surface_reset_target();

// 3rd Pass: Blur the bloom shader vertically.
// surfBlur -> surfBloom
shader_set_uniform_f(sBlurVector, 0, 1);

surface_set_target(surfBloom);
draw_surface(surfBlur, 0, 0);
surface_reset_target();

gpu_set_tex_filter(false);

// 4th Pass: Blending the bloom surface with the application surface.
// application_surface and surfBloom -> screen
shader_set(shaderBloomBlend);
shader_set_uniform_f(sBloomIntensity, bloomIntensity);
shader_set_uniform_f(sBloomDarken, bloomDarken);
shader_set_uniform_f(sBloomSaturation, bloomSaturation);
texture_set_stage(sBloomTexture, bloomTexture);

draw_surface(application_surface, 0, 0);

shader_reset();

// Return the game's GUI scaling to normal
display_set_gui_maximize(global.xScale, global.yScale, 0, 0);