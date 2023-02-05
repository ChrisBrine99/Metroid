/// @description Holds all of the code responsible for rendering the fog effect that can occur within the
/// game when necessary.

#region Initializing any macros that are useful/related to obj_weather_fog

// A simple macro that determines how many layers of fog there will be in the effect. Made into a macro
// so if the value ever needs to be adjusted it is as simple as changing this one line of code.
#macro	NUM_FOG_LAYERS				3

// A simple macro that replaces the value "64" that would be strewn about this code with something that
// actually explains what that number is; the size of the sprite--in both width and height--for the fog.
#macro	FOG_SIZE					64

#endregion

#region Initializing enumerators that are useful/related to obj_weather_fog
#endregion

#region Initializing any globals that are useful/related to obj_weather_fog
#endregion

#region The main object code for obj_weather_fog

function obj_weather_fog() constructor{
	// Much like Game Maker's own id variable for objects, this will store the unique ID value given to this
	// singleton, which is a value that is found in the "obj_controller_data" script with all the other
	// macros and functions for handling singleton objects.
	id = WEATHER_FOG_ID;
	
	// Create the array that is responsible for storing and managing all of the fog layer data structs in
	// the effect itself. They will simply store the position, movement velocities, scaling, and alpha level
	// of the fog sprite when it is rendered. All these structs will be created at once as soon as the 
	// array for storing them has been initialized.
	fogLayers = array_create(NUM_FOG_LAYERS, noone);
	
	// Used primarily for the fading animation that occurs at the starting and ending of the weather
	// effect. Depending on the current value of this variable, it will determine which fog layer is
	// currently having its alpha level lowered or increased, respective to the if the effect is starting
	// or ending.
	currentLayer = 0;
	
	// A simple flag that will signal to the code that the fog effect should begin its ending transition
	// that slowly fades each fog layer out from the latest in the array to the first element in it.
	isEnding = false;
	
	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_weather_fog. In short, it will handle updating the position values for all the different fog
	/// layers, and will also handle the fading in and out of said layers depending on if the weather
	/// effect is set to end or if it is just beginning.
	step = function(){
		// If the "isEnding" flag has been tripped, a check will begin to see if the first element in the
		// fog layer instance array is equal to a value of "noone". When that is true, it means that all
		// other layers have already been deleted and the struct is ready to be deleted as well.
		if (isEnding && fogLayers[0] == noone){
			delete WEATHER_FOG;
			WEATHER_FOG = noone;
			return; // No more code needs to be processed; exit the event early.
		}
		
		// Loop through all of the fog layers and update their positions using their unique velocity values;
		// clamping those values such that they never exceed the scaled dimensions for the sprite's width
		// and height. Also, update the alpha level for each layer depending on if the layer should fade
		// into visibility, or out of visibility (Determined by the "isEnding" flag.
		var _currentLayer, _isEnding, _deltaTime; // Store some local variables for faster access the structs.
		_currentLayer = currentLayer;
		_isEnding = isEnding;
		_deltaTime = DELTA_TIME;
		for (var i = 0; i < NUM_FOG_LAYERS; i++){
			with(fogLayers[i]){
				// If the "current layer" is the same value as the current layer that is being updates, it
				// means that its alpha level is the one that should be updated for the time being. Once that
				// alpha level has hit its target the value for this "current layer" can either increase by
				// a value of one, or decrease by that value. All determined by the value for the "isEnding"
				// flag. If "isEnding" is currently true, this layer will have its struct data deleted before
				// the next layer has begun its alpha processing.
				if (_currentLayer == i){
					alpha = value_set_linear(alpha, alphaTarget, 0.005);
					if (alpha == alphaTarget && !_isEnding){
						other.currentLayer++;
					} else if (alpha == alphaTarget && alphaTarget == 0){
						with(other){ // Jumps back into scope of the fog struct object to delete the fog layer's data.
							delete fogLayers[i];
							fogLayers[i] = noone;
							currentLayer--;
							break; // Exit the loop instantly.
						}
					}
				}
				
				// Updates the horizontal and vertical position of the fog layer based on its velocity
				// value for each and the currently value for delta time.
				x += hspd * _deltaTime;
				y += vspd * _deltaTime;
				
				// The two statements below will wrap the values of the x and y position for the fog layer
				// so that they always remain within the bounds of 0 to 64 * xScale/yScale.
				if (x < 0 || x >= FOG_SIZE * xScale)		{x -= FOG_SIZE * xScale * sign(hspd);}
				else if (y < 0 || y >= FOG_SIZE * yScale)	{y -= FOG_SIZE * yScale * sign(vspd);}
			}
		}
	}
	
	/// @description Code that should be placed into the "Draw End" event of whatever object is controlling
	/// obj_weather_fog. In short, it renders all of the fog layers as sprites tiled across the screen of
	/// a given hozitonal and vertical scale; plus a unique transparency level.
	draw_end = function(){
		gpu_set_tex_filter(true); // Turn on linear interpolation to minimize pixelation due to scaling.
		for (var i = 0; i < NUM_FOG_LAYERS; i++){
			with(fogLayers[i]){
				if (alpha == 0) {continue;} // Don't waste time rendering if the layer isn't visible.
				draw_sprite_tiled_ext(spr_fog, 0, floor(x), floor(y), xScale, yScale, c_white, alpha);
			}
		}
		gpu_set_tex_filter(false);
	}
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// obj_weather_fog.It simply loops through the array of fog layers in order to clear out any remaining
	/// data that wasn't deleted for whatever reason.
	cleanup = function(){
		for (var i = 0; i < NUM_FOG_LAYERS; i++){
			delete fogLayers[i];
			fogLayers[i] = noone;
		}
	}
	
	/// @description A simple function that contains the loop that creates all of the fog layers
	initialize_fog_layers = function(){
		for (var i = 0; i < NUM_FOG_LAYERS; i++){
			fogLayers[i] = {
				// Offset the starting X and Y positions for the sprite (Bascially, where it begins the tiling
				// for the sprite across the screen. (The default would be at (0,0), which is the top left corner
				// of the sprite) This ensures that each layer starts off at a wholly unique position relative
				// to the rest.
				x : random(FOG_SIZE - 1),
				y : random(FOG_SIZE - 1),
			
				// Determines the vertical and horizontal speed for the current fog layer; randomly selected
				// so that each layer moves uniquely. Randomly selected to prevent the flag layers from moving
				// in the same direction, which would look weird and boring.
				hspd : random_range(-0.75, 0.75),
				vspd : random_range(-0.75, 0.75),
			
				// Determines the scaling factor for the layer relative to the base dimensions of the sprite
				// used by each fog layer, which has a resolution of 64 by 64. Helps prevent it from looking
				// too uniform and boring if no random scaling occurred.
				xScale : random_range(1, 4),
				yScale : random_range(1, 4),
			
				// Simply determines the visibility of the layer on the screen. The second value determines
				// the target value for the alpha to reach; no matter if it's above or below said target.
				alpha : 0,
				alphaTarget : random_range(0.65, 1),
			};
		}
	}
}

#endregion

#region Global functions related to obj_weather_fog

/// @description Creates the struct that will be responsible for managing the fog effect in the game. 
/// Optionally, the starting animation can be skipped in order to have all the layers at their full 
/// visibility insntantly with no starting animation having them all slowly fade in from nothing. Useful 
/// for transitions between indoor and outdoor areas that already have the fog effect active, for example.
/// @param {Bool}	skipStartingAnimation
function effect_create_weather_fog(_skipStartingAnimation){
	if (WEATHER_FOG == noone){
		WEATHER_FOG = new obj_weather_fog();
		with(WEATHER_FOG){ // All fog layers are initialized here regardless of the animation flag.
			initialize_fog_layers();
			if (_skipStartingAnimation){
				for (var i = 0; i < NUM_FOG_LAYERS; i++){
					with(fogLayers[i]) {alpha = alphaTarget;}
					currentLayer++; // Increase this for each layer much like how the animation normally would.
				}
			}
		}
	}
}

/// @description Signals to the fog weather effect struct that it should end the rendering and updating of
/// the effect. Depending on the "_playEndingAnimation" flag's value, the struct will either be set up to
/// begin executing its closing animation, or it will simply be cleaned up and deleted instantly; skipping
/// said animation in its entirety. (Useful for transitioning between outdoor and indoor areas)
/// @param {Bool}	skipEndingAnimation
function effect_end_weather_fog(_skipEndingAnimation){
	with(WEATHER_FOG){
		if (!_skipEndingAnimation){
			for (var i = 0; i < NUM_FOG_LAYERS; i++){ // Sets all layers to begin fading out smoothly.
				with(fogLayers[i]) {alphaTarget = 0;}
			}
			// The variable "currentLayer" is set to high possible array index to begin deleting them from 
			// ending to start of the array; the opposite of how the starting animation would function.
			currentLayer = min(currentLayer, NUM_FOG_LAYERS - 1);
			isEnding = true;
		} else{
			cleanup(); // Handles cleaning up the fog layer data structs.
			delete WEATHER_FOG;
			WEATHER_FOG = noone;
		}
	}
}

#endregion