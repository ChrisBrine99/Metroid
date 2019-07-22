/// @description Initializing Variables
// You can write your code in this editor

// Getting all the shader stuff
shader = shd_blur;
sBlurSteps = shader_get_uniform(shader, "blur_steps");
sSigma = shader_get_uniform(shader, "sigma");
sTexelSize = shader_get_uniform(shader, "texel_size");
sBlurVector = shader_get_uniform(shader, "blur_vector");

// Variables that determine how blurry/how intense the shader will draw itself
blurSteps = 2;
sigma = 0.25;

// The surface that the application surface will be drawn to
surfBlur = -1;