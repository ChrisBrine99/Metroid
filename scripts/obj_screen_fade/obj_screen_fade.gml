/// @description A simple struct that handles and manages a visual effect that causes the screen to fade in
/// and out of a given color; hading that color completely fill the screen for a set number of in-game frames
/// (One "frame" is equal to 1/60th of a second--doesn't represent an actual in game frame because of delta
/// timing being implemented) before fading back out. All objects will be paused during this process.

#region Initializing any macros that are useful/related to obj_screen_fade

// A constant that will prevent the screen fade from automatically fading itself out once it reaches full
// opacity and it has depleted the value stored within the "fadeDuration" variable. When this value is set
// in the duration variable, the fade out must be manually triggered somewhere else within the code.
#macro	FADE_PAUSE_FOR_TOGGLE	   -250

#endregion

#region Initializing enumerators that are useful/related to obj_screen_fade
#endregion

#region Initializing any globals that are useful/related to obj_screen_fade
#endregion

#region The main object code for obj_screen_fade

/// @param {Id.Color}	fadeColor
/// @param {Real}		fadeSpeed
/// @param {Real}		fadeDuration
function obj_screen_fade(_fadeColor, _fadeSpeed, _fadeDuration) constructor{
	// Much like Game Maker's own id variable for objects, this will store the unique ID value given to this
	// singleton, which is a value that is found in the "obj_controller_data" script with all the other
	// macros and functions for handling singleton objects.
	id = SCREEN_FADE_ID;
	
	// The main variables that effect how the fade looks on the screen when it's executing its effect. The
	// first value will determine the color of the fade, the second will determine how fast the fade will
	// reach complete opacity and reach full transparency again, and the third will determine how long in
	// frames (1/60th of a real-world second) the effect will be fully opaque for.
	fadeColor =		_fadeColor;
	fadeSpeed =		_fadeSpeed;
	fadeDuration =	_fadeDuration;
	// NOTE -- The "fadeDuration" value can be set to "FADE_PAUSE_FOR_TOGGLE" which will prevent the effect
	// from fading out until it is signaled to by overwriting this value. Useful for things like loading 
	// screens where the length of loading time isn't known.
	
	// The variables that determine the current opacity of the screen fade, and the value it is trying to
	// move towards given its current state. (This value is either 0 or 1)
	alpha = 0;
	alphaTarget = 1;

	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_screen_fade. In short, it will handle fading the effect into full opacity, counting down the
	/// timer that causes a pause between the fade in and fade out, (This doesn't occur if the screen fade
	/// was set to remain fully opaque for an indefinite amount of time.) and fading the effect out of 
	/// visibility if the effect is required to do so.
	step = function(){
		alpha = value_set_linear(alpha, alphaTarget, fadeSpeed);
		if (fadeDuration != FADE_PAUSE_FOR_TOGGLE && alpha == 1 && alphaTarget == 1){ // Count down the duration until the fade out can begin.
			fadeDuration -= DELTA_TIME;
			if (fadeDuration <= 0) {alphaTarget = 0;}
		} else if (alpha == 0 && alphaTarget == 0){ // The fade has completed; clear its pointer from the singleton map.
			if (GAME_STATE_CURRENT == GameState.Paused) {game_set_state(GAME_PREVIOUS_STATE, true);}
			delete SCREEN_FADE;
			SCREEN_FADE = noone;
		}
	}
}

#endregion

#region Global functions related to obj_screen_fade

/// @description Creates an instance of the screen fade effect struct that will perform its fading effect
/// into the color provided, at the speed supplied for fading it in and out of visibility, while remaining
/// fully opaque for the duration in "frames" (1/60th of a real-world second) provided by the function.
/// @param {Id.Color}	fadeColor
/// @param {Real}		fadeSpeed
/// @param {Real}		fadeDuration
function effect_create_screen_fade(_fadeColor, _fadeSpeed, _fadeDuration){
	// If another screen fade struct currently exists within the singleton variable for managing any insatnces
	// of this effect, this function will simply exit before creating another insatnce of said struct.
	if (SCREEN_FADE != noone) {return;}
	
	// Create a new instance of the screen fade with the provided characteristics found in the three 
	// arguments values for this function; storing its unique pointer in the singleton management variable.
	// The game state will be set to "Paused" for the duration of the screen fade.
	SCREEN_FADE = new obj_screen_fade(_fadeColor, _fadeSpeed, _fadeDuration);
	if (GAME_CURRENT_STATE != GameState.Cutscene) {game_set_state(GameState.Paused);}
}

#endregion
