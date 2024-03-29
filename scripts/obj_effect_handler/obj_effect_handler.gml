#region	Initializing any macros that are useful/related to obj_effect_handler
#endregion

#region Initializing enumerators that are useful/related to obj_effect_handler
#endregion

#region Initializing any globals that are useful/related to obj_effect_handler

// A list that stores the instance ID values for all lighting components that are currently active within
// the game; allowing them to be rendered in a single batch within the effect handler's draw event.
global.lightSources = ds_list_create();

// FOR DEBUGGING -- Counts how many light sources were drawn in a frame.
global.lightsDrawn = 0;

#endregion

#region The main object code for obj_effect_handler

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_effect_handler(_index) : base_struct(_index) constructor{	
	// Stores the current texel values for the application surface, which is a normalized value for a single
	// pixel relative to the dimensions of said surface. Since the aspect ratio can be altered in the game,
	// these variables will be updated to store the proper texel sizes for any changes that occur.
	windowTexelWidth = 0;
	windowTexelHeight = 0;
	
	// 
	surfWorld = -1;
	surfLights = -1;
	
	// 
	sWorldColor			= shader_get_uniform(shd_lighting, "color");
	sWorldBrightness	= shader_get_uniform(shd_lighting, "brightness");
	sWorldSaturation	= shader_get_uniform(shd_lighting, "saturation");
	sWorldContrast		= shader_get_uniform(shd_lighting, "contrast");
	sWorldLights		= shader_get_sampler_index(shd_lighting, "lightTexture");
	
	// Parameters for the world's lighting system that allows a fine-tuning of the current room's ambient
	// lighting; the color to use, the overall brightness of unlit objects, as well as the saturation and
	// contrasts of those unlit pixels in the view.
	worldColor = RGB_GRAY;
	worldBrightness = -0.25;
	worldSaturation = 0.65;
	worldContrast = 0.8;
	
	// Stores the result for the first passing of the blurring process. The second pass is drawn to the
	// surface that was used initially, so it doesn't need its own dedicated surface.
	surfBlurBuffer = -1;
	
	// Store each of the uniforms required for the blurring shader to their own unique variables, which are
	// then used again when rendering with the blur shader to apply the correct settings to it; creating
	// the desired effect based on the settings applied to said uniforms.
	sBlurRadius		= shader_get_uniform(shd_screen_blur, "blurRadius");
	sBlurIntensity	= shader_get_uniform(shd_screen_blur, "blurIntensity");
	sBlurTexelSize	= shader_get_uniform(shd_screen_blur, "blurTexelSize");
	sBlurDirection	= shader_get_uniform(shd_screen_blur, "blurDirection");
	
	// Parameters for the screen blur effect that allow for the adjustment of the amount of samples per pixel
	// that are required by the effect within the shader, as well as how much of an effect the blurring will
	// have only the final image that is rendered for the player to see.
	blurRadius			= 0;
	blurRadiusTarget	= 0;
	blurRadiusModifier	= 0;
	blurAmount			= 0;
	blurAmountTarget	= 0;
	blurAmountModifier	= 0.001;
	
	// The surface that is used for achieving the game's blooming effect. The surface index is stored in the
	// first variable, and the texture ID for that surface is stored in the second variable so it can be used
	// as a sampler in the bloom blend shader.
	surfBloomLum = -1;
	bloomTextureID = -1;
	
	// Determines the range of colors that are affected by blooming; any colors that surpass the threshold 
	// will have a bloom effect applied (The amount of bloom being determined by how far that color is below
	// the "threshold" relative to the range value).
	sBloomThreshold	= shader_get_uniform(shd_bloom_luminance, "threshold");
	sBloomRange		= shader_get_uniform(shd_bloom_luminance, "range");
	
	// Uniforms for the bloom effect. The first determines how intense the blooming effect is at the current
	// moment in-game, the second determines how pronounced the bloom is relative to the rest of the screen
	// that isn't affected, the third determines how saturated the bloomed colors become, and the final
	// allows the bloom surface to be used as an additional sample texture in the bloom shader for accurate
	// blending onto the application surface.
	sBloomIntensity		= shader_get_uniform(shd_bloom_blend, "intensity");
	sBloomDarken		= shader_get_uniform(shd_bloom_blend, "darkenAmount");
	sBloomSaturation	= shader_get_uniform(shd_bloom_blend, "saturation");
	sBloomTexture		= shader_get_sampler_index(shd_bloom_blend, "bloomTexture");
	
	// The uniform that is responsible for determining how intense the chromatic aberration effect is on the
	// screen. A higher values means the effect begins closer to the center of the screen, and the effect at
	// the outer edges is more defined.
	sAbrIntensity		= shader_get_uniform(shd_aberration, "intensity");
	
	// Parameters for the optional film grain effect that is applied to the game's GUI layer. The offset values
	// are updated every frame to mimic the sporadic nature of the actual effect on a reel of film, and the
	// alpha can be updated whenever the target value is different from the current value; allowing smooth
	// transitions between this effect being active and not active
	fgSize = sprite_get_width(spr_film_grain);
	fgOffsetX = 0;
	fgOffsetY = 0;
	fgAlpha = 0;
	fgAlphaTarget = 0;
	fgAlphaModifier = 0;
	
	// Stores the uniform location within the shader for the parameter that is responsible for determining
	// how transparent the scanlines are on the screen when the effect is enabled by the player.
	sScanlineOpacity	= shader_get_uniform(shd_scanlines, "opacity");
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// obj_effect_handler. In short, it will cleanup any data that needs to be freed from memory that isn't 
	/// collected by Game Maker's built-in garbage collection handler.
	cleanup = function(){
		if (surface_exists(surfWorld))		{surface_free(surfWorld);}
		if (surface_exists(surfLights))		{surface_free(surfLights);}
		if (surface_exists(surfBloomLum))	{surface_free(surfBloomLum);}
		if (surface_exists(surfBlurBuffer)) {surface_free(surfBlurBuffer);}
	}
	
	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_effect_handler. In short, it will update any variables/effects that need to be altered on a
	/// frame-by-frame basis. (Ex. Smoothly fading blur/grain effects in and out)
	step = function(){
		blurAmount	= value_set_relative(blurAmount, blurAmountTarget, blurAmountModifier);
		fgAlpha		= value_set_linear(fgAlpha, fgAlphaTarget, fgAlphaModifier);
	}
	
	/// @description Code that should be placed into the "Draw End" event of whatever object is controlling 
	/// obj_effect_handler. In short, it will apply all of the currently active post-processing effects onto 
	/// the screen in world-space BEFORE any UI elements are rendered, but after everything else has been drawn.
	draw_end = function(){
		apply_world_lighting();
	}
	
	/// @description Code that should be placed into the "Draw GUI Begin" event of whatever object is 
	/// controlling obj_effect_handler. In short, it will render graphical effects to the screen that above 
	/// the application surface, but BEFORE the game's GUI surface. For example, the screen blurring and
	/// bloom effects are applied here.
	/// @param {Real}	width		The width in pixels of the GUI surface.
	/// @param {Real}	height		The height in pixels of the GUI surface.
	draw_gui_begin = function(_width, _height){
		if (game_get_setting_flag(BLOOM_EFFECT))		{apply_screen_bloom(_width, _height);}
		//if (game_get_setting_flag(ABERRATION_EFFECT))	{apply_aberration(0.0);}
		apply_screen_blurring(application_surface, round(blurRadius), blurAmount);
	}
	
	/// @description Code that should be placed into the "Draw GUI End" event of whatever object is controlling
	/// obj_effect_handler. In short, it will render graphical effects to the screen that above both the
	/// application surface AND the game's GUI surface. For example, both the scanlines and noise filter are
	/// applied here to overlap the entire image.
	/// @param {Real}	width		The width in pixels of the GUI surface.
	/// @param {Real}	height		The height in pixels of the GUI surface.
	draw_gui_end = function(_width, _height){
		if (game_get_setting_flag(FILM_GRAIN_FILTER))	{apply_film_grain();}
		if (game_get_setting_flag(SCANLINE_FILTER))		{apply_scanlines(_width, _height, 0.15);}
	}
	
	/// @description Renders the world using the current global illumination parameters (brightness, contrast,
	/// and saturation) alongside any on-screen lights to determine how the world currently looks from the
	/// camera's point of view.
	apply_world_lighting = function(){
		// Grab and store characteristics about the camera's current viewport for use during the rendering
		// of each light source and whether or not the light is even rendered to begin with.
		var _camera			= CAMERA.camera;
		var _cameraX		= camera_get_view_x(_camera);
		var _cameraY		= camera_get_view_y(_camera);
		var _cameraWidth	= camera_get_view_width(_camera);
		var _cameraHeight	= camera_get_view_height(_camera);
		
		// FOR DEBUGGING -- Reset value stored in "lightsDrawn" global for the new frame.
		global.lightsDrawn = 0;
		
		// Since the world lighting is the first effect that is applied to the application surface, it will be
		// created here; drawing the application surface to it so it can be manipulated through subsequent passes
		// of varying shader/post-processing effects.
		if (!surface_exists(surfWorld))	{surfWorld = surface_create(_cameraWidth, _cameraHeight);}
		surface_set_target(surfWorld);
		draw_surface(application_surface, 0, 0);
		surface_reset_target();
		
		// Create the light surface texture if it doesn't currently exist within the GPUs VRAM due to a flush
		// of GPU memory that may have occurred during runtime. The texture ID for that surface is grabbed
		// immediately after the surface's initialization since its value never changes.
		if (!surface_exists(surfLights)){
			surfLights = surface_create(_cameraWidth, _cameraHeight);
			texLights = surface_get_texture(surfLights);
		}
		
		// The lights in the world need to be rendered onto a seperate surface before they can be added to the
		// world surface during the shader's execution. The light will immediately be turned completely black
		// before lights are additively blended on top of that.
		surface_set_target(surfLights);
		draw_clear(HEX_BLACK); // make the surface completely black
		gpu_set_blendmode(bm_add);
		
		// Loop through all light sources and render them onto the light source surface texture. Lights that
		// are inactive or not visible within the camera's current viewport will be skipped over in the process;
		// ensuring only visible lights are actually rendered.
		var _x = 0;
		var _y = 0;
		var _length = ds_list_size(global.lightSources);
		for (var i = 0; i < _length; i++){
			with(global.lightSources[| i]){
				if (!isActive || radius == 0 || strength <= 0.0) 
					continue;
				
				_x = x - _cameraX;
				_y = y - _cameraY;
				if (_x + radius > 0 && _x - radius < _cameraWidth &&
					_y + radius > 0 && _y - radius < _cameraHeight){
					draw_set_alpha(strength);
					draw_ellipse_color(_x - radius, _y - radius, _x + radius, _y + radius, color, c_black, false);
					global.lightsDrawn++;
				}
			}
		}
		draw_set_alpha(1);
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		
		// Once the light surface texture has been prepared, the lighting shader will be applied to the world
		// surface, which is drawn after all uniforms have been properly set up. It will be drawn at the position
		// of the camera within room and not at (0, 0) due to the lighting system existing in world-space and
		// not GUI space.
		shader_set(shd_lighting);
		shader_set_uniform_f_array(sWorldColor, worldColor);
		shader_set_uniform_f(sWorldBrightness, worldBrightness);
		shader_set_uniform_f(sWorldSaturation, worldSaturation);
		shader_set_uniform_f(sWorldContrast, worldContrast);
		texture_set_stage(sWorldLights, texLights);
		draw_surface(surfWorld, _cameraX, _cameraY);
		shader_reset();
	}
	
	/// @description Applies a blur across the entire screen; the resulting blur being determined by the surface
	/// that is used as the "base" for the blurring, the maximum radius of it, and the "amount" to blur (This
	/// value will increase or decrease the overall blur depending on its value).
	/// @param {Id.Surface}	baseSurface		What is used as the initial sample for the effect (Effect overwrites with final pass).
	/// @param {Real}		blurRadius		How many pixels will be sampled for each pixel; total amount required being 2 * blurRadius.
	/// @param {Real}		blurAmount		Determines the overall visibility of the blurring on the surface.
	apply_screen_blurring = function(_baseSurface, _blurRadius, _blurAmount){
		// Don't waste time attempting to render the screen blur if there isn't a possibility of it being
		// visible to the user due to either of these two parameters being zeroed out.
		if (_blurRadius == 0 || _blurAmount == 0) 
			return;
		
		// Make sure the buffer surface for the blurring effect exists within the GPU's memory before
		// any processing of the effect has begun. It's dimensions are the same as the window's.
		if (!surface_exists(surfBlurBuffer)){
			var _camera = CAMERA.camera;
			surfBlurBuffer = surface_create(camera_get_view_width(_camera), 
									camera_get_view_height(_camera));
		}
		
		// First, the shader will be activated and the main parameters will be set; the radius of the blur,
		// (This determines how many pixels around the current fragment will effect the final color of said
		// fragment) its intensity, (How blurry the image will be overall) and the values for the texel
		// width and height of each pixel for the screen. (THese are normalized values between 0 and 1)
		shader_set(shd_screen_blur);
		shader_set_uniform_f(sBlurRadius, _blurRadius);
		shader_set_uniform_f(sBlurTexelSize, windowTexelWidth, windowTexelHeight);
		shader_set_uniform_f(sBlurIntensity, _blurAmount);
		
		// Once the parameters for the shader have been properly set/updated, the first pass of the shader
		// will draw the application surface to the blur's buffer surface; applying the horizontal blurring
		// to it. (What axis is blurred first doesn't actually matter to the shader)
		shader_set_uniform_f(sBlurDirection, 1, 0);
		surface_set_target(surfBlurBuffer);
		draw_surface(_baseSurface, 0, 0);
		surface_reset_target();
		
		// After the first pass is completed, the buffer surface containing that first pass texture will be
		// redrawn to the initial surface; blurring it on the remaining axis to complete the blur effect.
		shader_set_uniform_f(sBlurDirection, 0, 1);
		surface_set_target(_baseSurface);
		draw_surface(surfBlurBuffer, 0, 0);
		surface_reset_target();
		shader_reset();
	}
	
	/// @description The function that handles rendering the bloom effect in the game. This effect will
	/// result in a bright blur on pixels that are already bright to begin with; increasing the overall
	/// contrast of the image and also mimicking how our eyes and camera lenses react to very bright colors.
	/// @param {Real}	width		The width in pixels of the GUI surface.
	/// @param {Real}	height		The height in pixels of the GUI surface.
	apply_screen_bloom = function(_width, _height){
		// First, make sure the surface used to store the pixels on the screen that are bright enough to
		// be altered by this screen blooming function. The ID given to that surface is also stored since
		// it is required for the blending of the luminance surface and the application surface.
		if (!surface_exists(surfBloomLum)){
			surfBloomLum	= surface_create(_width, _height);
			bloomTextureID	= surface_get_texture(surfBloomLum);
		}
		
		// First, the luminance for the application surface is calculated using the respective shader for
		// parsing out those bright pixels. The threshold for which pixels are grabbed from the application
		// surface or not is set, and the range that "fades out" the bright pixels to darken (threshold - 
		// range; anything lower than that result is pure black on the surface) relative to the completely
		// affected pixels.
		shader_set(shd_bloom_luminance);
		shader_set_uniform_f(sBloomThreshold, 0.75);
		shader_set_uniform_f(sBloomRange, 0.1);
		surface_set_target(surfBloomLum);
		draw_surface(application_surface, 0, 0);
		surface_reset_target();
		shader_reset();
		
		// Next, the blurring shader needs to be utilized in order to create the bloom effect using the
		// luminance shader that was calculated with the first shader pass above. After this, a blurred
		// surface is created to then be blended with the base application surface.
		apply_screen_blurring(surfBloomLum, 3, 0.2);

		// The next and final shader pass for this blooming effect is executed here; determining how the
		// blending will occur between the bloom luminance surface and the base application surface.
		// These values along with a saturation to add a little more to the blooming all have their values
		// set to prepare them for use in rendering.
		shader_set(shd_bloom_blend);
		shader_set_uniform_f(sBloomIntensity, 1);
		shader_set_uniform_f(sBloomDarken, 0.9);
		shader_set_uniform_f(sBloomSaturation, 0.4);
		
		// In order to blend the surfaces, the texture ID for the bloom luminance surface is send to the
		// shader; allowing it to reference colors wihtin that surface for use in the base texture's color.
		// The bloom surface has its interpolation turned on to make the blooming smooth.
		texture_set_stage(sBloomTexture, bloomTextureID);
		draw_surface(application_surface, 0, 0);
		shader_reset();
	}
	
	/// @description Applies a chromatic aberration effect to the game's viewport; having its intensity 
	/// increase the further the pixel on the screen is from the center of the screen.
	/// @param {Real}	intensity	Determines how pronounced the aberration effect will be.
	apply_aberration = function(_intensity){
		shader_set(shd_aberration);
		shader_set_uniform_f(sAbrIntensity, _intensity);
		draw_surface(application_surface, 0, 0);
		shader_reset();
	}
	
	/// @description Applies an optional film grain effect onto the GUI layer of the game; tiling it across
	/// the entire GUI layer. The offset of said tiling is randomized beforehand every frame.
	apply_film_grain = function(){
		if (fgAlpha == 0) {return;} // Skip effect if not visible at the moment.
		fgOffsetX = irandom_range(-fgSize, fgSize) + 1;
		fgOffsetY = irandom_range(-fgSize, fgSize) + 1;
		draw_sprite_tiled_ext(spr_film_grain, 0, fgOffsetX, fgOffsetY, 1, 1, c_white, fgAlpha);
	}
	
	/// @description Creates the per-pixel scanline effect to the screen; the final step in the post-processing
	/// effect pipeline for the game. It will temporarily match the GUI's dimensions to the display that the
	/// game is being rendered to in order to achieve this effect; ignoring the scaling factors of the game's
	/// actual resolution.
	/// @param {Real}	width		The width in pixels of the GUI surface.
	/// @param {Real}	height		The height in pixels of the GUI surface.
	/// @param {Real}	opacity		Determines how intense the scanlines are (0.0 = transparent, 1.0 = opaque).
	apply_scanlines = function(_width, _height, _opacity){
		// Local variables that store information about the GUI's width and height prior to the scanline effect
		// being rendered onto the screen, as well as the temporary resolution that matches the resolution of
		// the player's monitor.
		var _scale		= RESOLUTION_SCALE;
		var _tempWidth	= _width * _scale;
		var _tempHeight = _height * _scale;
		display_set_gui_size(_tempWidth, _tempHeight);
		
		// Activate the shader, and then simply draw a rectangle across the entire screen. The shader will turn
		// it black, set its opacity, and remove every other pixel to finalize the effect.
		shader_set(shd_scanlines);
		shader_set_uniform_f(sScanlineOpacity, _opacity);
		draw_sprite_ext(spr_rectangle, 0, 0, 0, _tempWidth, _tempHeight, 0, c_white, 1);
		shader_reset();
		
		// After the scanlines have been rendered at the resolution matching the player's active monitor (The
		// one displaying the game's window), return the size of the gui surface back to the same size as the
		// game's world-space resolution (320 by 180).
		display_set_gui_size(_width, _height);
	}
}

#endregion

#region Global functions related to obj_effect_handler

/// @description Determines the ambient color of the world (AKA the color where there are no light sources
/// influencing the final color).
/// @param {Array<Real>}	color			The base color to use for the lighting.
/// @param {Real}			brightness		Determines how bright the final ambient lighting output will be.
/// @param {Real}			saturation		Pronounces or diminishes the world's colors when only affected by the ambient light.
/// @param {Real}			contrast		Increases/decreases distance between lightest and darkest color outside of any light sources.
function effect_set_world_lighting(_color, _brightness, _saturation, _contrast){
	with(EFFECT_HANDLER){
		array_copy(worldColor, 0, _color, 0, 3); // Length of three [R, G, B].
		worldBrightness	= _brightness;
		worldSaturation = _saturation;
		worldContrast	= _contrast;
	}
}

/// @description Applies an independent blurring effect (Not related to the blurring pass used in the bloom
/// effect) to the application surface that updates in real-time according to these parameters and what the
/// current parameters once were.
/// @param {Real}	radius		Determines number of samples taken from neighboring pixels to create the blur (2 * radius is the amount of samples required per pixel for overall effect).
/// @param {Real}	intensity	Overall blurring intensity; higher values means the blur is more pronounced and lower values create a more subtle effect.
/// @param {Real}	modifier	Determines how fast/slow the blurring effect updates on the screen.
function effect_apply_screen_blur(_radius, _intensity, _modifier){
	with(EFFECT_HANDLER){
		intensityTarget		= clamp(_intensity, 0, 1);
		intensityModifier	= _modifier;
	}
}

/// @description Removes all of the light sources from memory that aren't set to persistent whenever a room
/// has triggered its "Room End" event (This function should be called by "obj_controller" in its "Room End"
/// for this very purpose. Without this function all light sources will be lost in memory since the objects
/// they were previously attached to might not exist within the next room.
function effect_unload_room_lighting(){
	// First, create a new list that will become the global light sources list once all the non-persistent
	// lights have been cleared out of memory. Persistent are carried over into this list.
	var _persistentLights = ds_list_create();
	
	// Loop through all light sources that currently exist within the room; carrying them over to the next
	// room or removing it from memory depending on the value of each of their "isPersistent" flags.
	var _length, _light;
	_length = ds_list_size(global.lightSources);
	for (var i = 0; i < _length; i++){
		_light = global.lightSources[| i];
		// The current light is a persistent light source, (Ex. The player's flashlight) so it will be
		// carried over to the new list for all light sources.
		if (_light.isPersistent){
			ds_list_add(_persistentLights, _light);
			continue; // Skips to the next index instently
		}
		// The current light source isn't persistent; delete it from memory before moving onto the next index.
		delete global.lightSources[| i];
	}
	
	// After the previous list has had all its non-persistent light sources cleared from it, the list will
	// be destroyed from memory and the pointer to the persistent light source list will be carried into the
	// global.lightSources variable; making that list the new light source management list.
	ds_list_destroy(global.lightSources);
	global.lightSources = _persistentLights;
}

#endregion