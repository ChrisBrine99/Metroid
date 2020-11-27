/// @description Variable Initialization

#region	SINGLETON CHECK

if (global.effectID != noone){
	if (global.effectID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.effectID);
}
global.effectID = id;

#endregion

#region EDIT INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Variables that store the resulting surface after all effects have been processed; with two auxillary
// surfaces that act as buffers to store the application surface whenever multiple passes are used in 
// a shader's effect.
resultSurface = -1;
auxSurfaceA = -1;
auxSurfaceB = -1;

// These three variables store the texture ID for the result and auxillary surfaces that cna easily be
// passed to the currently active shader.
resultTexture = -1;
auxTextureA = -1;
auxTextureB = -1;

// A variable that stores the reference to the texture ID

// Variables for Lighting Shader ///////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
lightShader = shd_lighting;
// Get the uniform locations; storing them in local variables
sColor =			shader_get_uniform(lightShader, "color");
sBrightness =		shader_get_uniform(lightShader, "brightness");
sContrast =			shader_get_uniform(lightShader, "contrast");
sSaturation =		shader_get_uniform(lightShader, "saturation");
sLightTexture =		shader_get_sampler_index(lightShader, "lightTexture");

lightColor = [1, 1, 1];
lightBrightness = 0;
lightContrast = 1;
lightSaturation = 1;

// A flag that toggles the lighting system on and off.
lightingEnabled = true;

////////////////////////////////////////////////////////////////////////////////////

// Variable for the Bloom Shaders //////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
bloomShaderLuminence = shd_bloom_luminence;
// Get the uniform locations; storing them in local variables
sBloomThreshold =	shader_get_uniform(bloomShaderLuminence, "bloomThreshold");
sBloomRange =		shader_get_uniform(bloomShaderLuminence, "bloomRange");

// This variable holds a reference to the shader's unique asset index value.
bloomShaderBlend = shd_bloom_blend;
// Get the uniform locations; storing them in local variables
sBloomIntensity =	shader_get_uniform(bloomShaderBlend, "bloomIntensity");
sBloomDarken =		shader_get_uniform(bloomShaderBlend, "bloomDarken");
sBloomSaturation =	shader_get_uniform(bloomShaderBlend, "bloomSaturation");
sBloomTexture =		shader_get_sampler_index(bloomShaderBlend, "bloomTexture");

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Blur Shader ///////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
blurShader = shd_blur;
// Get the uniform locations; storing them in local variables
sBlurSteps =		shader_get_uniform(blurShader, "blurSteps");
sTexelSize =		shader_get_uniform(blurShader, "texelSize");
sSigma =			shader_get_uniform(blurShader, "sigma");
sBlurVector =		shader_get_uniform(blurShader, "blurVector");

// A flag that toggles the blur effect on and off.
blurEnabled = false;

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Chromatic Aberration Shader ///////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
abrerrationShader = shd_chromatic_aberration;
// Get the uniform locations; storing them in local variables
sAberration =		shader_get_uniform(abrerrationShader, "aberration");

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Heat Haze Shader //////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
heatHazeShader = shd_heat_haze;
// Get the uniform locations; storing them in local variables
sHazeTime =			shader_get_uniform(heatHazeShader, "time");
sHazeSize =			shader_get_uniform(heatHazeShader, "size");
sHazeStrength =		shader_get_uniform(heatHazeShader, "strength");
sHazeTexture =		shader_get_sampler_index(heatHazeShader, "hazeTexture");

// A flag that enables the heat haze effect
isHazeEnabled = false;

// A variable that holds the texture ID for the heat haze sprite used in this shader.
// The variable below that one tracks the time used to move the shader's effect around.
hazeTexture = sprite_get_texture(spr_heat_haze, 0);
time = 0;

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Scanline Shader ///////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
scanlineShader = shd_scanlines;
// Get the uniform locations; storing them in local variables
sViewHeight =		shader_get_uniform(scanlineShader, "viewHeight");
sStrength =			shader_get_uniform(scanlineShader, "strength");

////////////////////////////////////////////////////////////////////////////////////

// Disable the automatic drawing of the application surface
application_surface_draw_enable(false);

#endregion/