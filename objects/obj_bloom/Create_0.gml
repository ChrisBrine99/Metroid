/// @description Insert description here
// You can write your code in this editor

// Destroy if another camera already exists
if (global.bloomID != noone){
	if (global.bloomID.object_index == obj_bloom){
		instance_destroy(self);	
	}
}
global.bloomID = instance_id;

// Getting Shader stuff for the parts of the screen that will be blurred
shaderBloomLuminence = shd_bloom_filter_luminence;

sBloomThreshold = shader_get_uniform(shaderBloomLuminence, "bloomThreshold");
sBloomRange = shader_get_uniform(shaderBloomLuminence, "bloomRange");
sAppTexture = shader_get_sampler_index(shaderBloomLuminence, "appTexture");

// The properties that determine how bright a color needs to be to have bloom applied
bloomThreshold = 0.4;
bloomRange = 0.1;

// Getting shader stuff that wil alter how intense the blooming is
shaderBloomBlend = shd_bloom_filter_blend;

sBloomIntensity = shader_get_uniform(shaderBloomBlend, "bloomIntensity");
sBloomDarken = shader_get_uniform(shaderBloomBlend, "bloomDarken");
sBloomSaturation = shader_get_uniform(shaderBloomBlend, "bloomSaturation");
sBloomTexture = shader_get_sampler_index(shaderBloomBlend, "bloomTexture");

// The properties that determines how intense, darkened, and saturated the bloom is overall
bloomIntensity = 1.1;
bloomDarken = 0.9;
bloomSaturation = 1.0;

// Getting Shader stuff for the blurring of the resulting luminence shader
shaderBlur = shd_blur;

sBlurSteps = shader_get_uniform(shaderBlur, "blur_steps");
sSigma = shader_get_uniform(shaderBlur, "sigma");
sTexelSize = shader_get_uniform(shaderBlur, "texel_size");
sBlurVector = shader_get_uniform(shaderBlur, "blur_vector");

// The properties for determining how intense the blurring of select colors will be
blurSteps = 4;
sigma = 0.15;

// Two surfaces; one for bluring, and one for getting only the bright colors on the screen
surfBloom = -1;
surfBlur = -1;

// The variable that holds the id value for the bloom texture
bloomTexture = -1;
appTexture = -1;