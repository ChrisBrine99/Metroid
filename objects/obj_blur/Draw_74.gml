/// @description Rendering the shader
// You can write your code in this editor

display_set_gui_maximize(1, 1, global.xOffset, global.yOffset);

shader_set(shader);

// Create the surface if it doesn't exist
if (!surface_exists(surfBlur)){
	surfBlur = surface_create(global.camWidth, global.camHeight);
	surface_resize(surfBlur, global.camWidth * global.xScale, global.camHeight * global.yScale);
}

shader_set_uniform_f(sBlurSteps, blurSteps);
shader_set_uniform_f(sTexelSize, 1 / global.camWidth, 1 / global.camHeight);
shader_set_uniform_f(sSigma, sigma);

// 1st Pass (Horizontal) -> Drawing application surface to srfPing
shader_set_uniform_f(sBlurVector, 1, 0);
surface_set_target(surfBlur);
draw_surface(application_surface, 0, 0);
surface_reset_target();

// 2nd Pass (Vertical) -> Drawing srfPing to the screen
shader_set_uniform_f(sBlurVector, 0, 1);
draw_surface(surfBlur, 0, 0);

shader_reset();

display_set_gui_maximize(global.xScale, global.yScale, global.xOffset, global.yOffset);