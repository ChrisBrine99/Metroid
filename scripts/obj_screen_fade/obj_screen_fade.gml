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

/// @param {Real}	index
function obj_screen_fade(_index) : base_struct(_index) constructor{
	// The main variables that effect how the fade looks on the screen when it's executing its effect. The
	// first value will determine the color of the fade, the second will determine how fast the fade will
	// reach complete opacity and reach full transparency again, and the third will determine how long in
	// frames (1/60th of a real-world second) the effect will be fully opaque for.
	fadeColor		= HEX_WHITE;
	fadeSpeed		= 0;
	fadeDuration	= 0;
	// NOTE -- The "fadeDuration" value can be set to "FADE_PAUSE_FOR_TOGGLE" which will prevent the effect
	// from fading out until it is signaled to by overwriting this value. Useful for things like loading 
	// screens where the length of loading time isn't known.
	
	// The variables that determine the current opacity of the screen fade, and the value it is trying to
	// move towards given its current state. (This value is either 0 or 1)
	alpha		= 0.0;
	alphaTarget = 1.0;
	
	// 
	playerX		= 0;
	playerY		= 0;
	pTargetX	= 0;
	pTargetY	= 0;
	drawPlayer	= true;
	
	// 
	prevAnimationFlags = ds_list_create();

	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_screen_fade. In short, it will handle fading the effect into full opacity, counting down the
	/// timer that causes a pause between the fade in and fade out, (This doesn't occur if the screen fade
	/// was set to remain fully opaque for an indefinite amount of time.) and fading the effect out of 
	/// visibility if the effect is required to do so.
	step = function(){
		alpha = value_set_linear(alpha, alphaTarget, fadeSpeed);
		if (fadeDuration != FADE_PAUSE_FOR_TOGGLE && alpha == 1.0 && alphaTarget == 1.0){ // Count down the duration until the fade out can begin.
			fadeDuration -= DELTA_TIME;
			if (fadeDuration <= 0.0) 
				alphaTarget = 0.0;
		} else if (alpha == 0.0 && alphaTarget == 0.0){ // The fade has completed; clear its pointer from the singleton map.
			// Reset the game's state back to what it was prior to the screen fade. All entities will have their
			// "freeze animation" flags returned to whatever they were before the fade as well.
			if (GAME_CURRENT_STATE == GSTATE_PAUSED){
				game_set_state(GAME_PREVIOUS_STATE, true);
				var _length = ds_list_size(prevAnimationFlags);
				var _data	= [noone, false]; // All elements in the list should match the format of this default value.
				for (var i = 0; i < _length; i++){
					_data = prevAnimationFlags[| i];
					with(_data[0]){ // 0th index should always be the entity's unique ID value.
						if (_data[1] != 0) {continue;} // Ignore any entities that already had their animations frozen.
						stateFlags &= ~ENTT_PAUSE_ANIM;
					}
				}
				ds_list_clear(prevAnimationFlags);
			}
		}
	}
	
	/// @description
	cleanup = function(){
		ds_list_destroy(prevAnimationFlags);
	}
	
	/// @description Code that should be placed into the "Draw" event of whatever object is controlling
	/// obj_screen_fade. It will draw a rectangle onto the screen in the color specified by the fade effect
	/// parameters. The current opacity is determined by the alpha variable's current value. Optionally, the
	/// player can be draw above the fade effect, which is normally only used during room transitions.
	/// @param {Real}	width		The width in pixels of the GUI surface.
	/// @param {Real}	height		The height in pixels of the GUI surface.
	draw_gui = function(_width, _height){
		if (alpha == 0.0) 
			return;
		draw_sprite_ext(spr_rectangle, 0, 0, 0, _width, _height, 0, fadeColor, alpha);
		
		// 
		if (!drawPlayer)
			return;
			
		// 
		var _alpha		= alpha;
		var _playerX	= playerX;
		var _playerY	= playerY;
		with(PLAYER){
			// 
			draw_sprite_ext(sprite_index, imageIndex, _playerX, _playerY, image_xscale, image_yscale, 
								image_angle, image_blend, _alpha);
			
			// 
			with(armCannon){
				if (!visible) 
					break;
				draw_sprite_ext(spr_samus_cannon0, imageIndex, _playerX + x,_playerY + y, image_xscale, 
				1.0, 0.0, c_white, _alpha);
			}
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
/// @param {Bool}		drawPlayer
function effect_create_screen_fade(_fadeColor, _fadeSpeed, _fadeDuration, _drawPlayer = true){
	with(SCREEN_FADE){
		// Don't attempt to "create" another screen fade effect (One struct manages it that is created at the
		// start of execution) if there is currently a screen fade already occurring.
		if (alpha != 0.0 && alphaTarget != 0.0) 
			return;
		alpha		= 0.0;
		alphaTarget = 1.0;
		
		fadeColor	 = _fadeColor;
		fadeSpeed	 = _fadeSpeed;
		fadeDuration = _fadeDuration;
		drawPlayer	 = _drawPlayer;
		
		var _animationFlags = prevAnimationFlags;
		with(par_dynamic_entity){ // Freezes animations for all dynamic entities (They can move around the world).
			ds_list_add(_animationFlags, [id, ENTT_IS_ANIM_PAUSED]);
			stateFlags |= ENTT_PAUSE_ANIM;
		}
		with(par_static_entity){ // Freezes animations of all static entities (They almost never move around the game world).
			ds_list_add(_animationFlags, [id, ENTT_IS_ANIM_PAUSED]);
			stateFlags |= ENTT_PAUSE_ANIM;
		}
	}
	
	// Pause the game outright if there isn't a cutscene currently being executed. Otherwise, the last game
	// state would become the paused state and the game would softlock after the cutscene finished.
	if (GAME_CURRENT_STATE != GSTATE_CUTSCENE)
		game_set_state(GSTATE_PAUSED);
}

#endregion
