/// @description A simple struct that handles and manages a visual effect that causes the screen to fade in
/// and out of a given color; hading that color completely fill the screen for a set number of in-game frames
/// (One "frame" is equal to 1/60th of a second--doesn't represent an actual in game frame because of delta
/// timing being implemented) before fading back out. All objects will be paused during this process.

#region Initializing any macros that are useful/related to obj_screen_fade

// A constant that will prevent the screen fade from automatically fading itself out once it reaches full
// opacity and it has depleted the value stored within the "fadeDuration" variable. When this value is set
// in the duration variable, the fade out must be manually triggered somewhere else within the code.
#macro	FADE_PAUSE_FOR_TOGGLE	   -250

// 
#macro	SURFACE_OFFSET_X			4
#macro	SURFACE_OFFSET_Y			4

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
	fadeColor =		HEX_WHITE;
	fadeSpeed =		0;
	fadeDuration =	0;
	// NOTE -- The "fadeDuration" value can be set to "FADE_PAUSE_FOR_TOGGLE" which will prevent the effect
	// from fading out until it is signaled to by overwriting this value. Useful for things like loading 
	// screens where the length of loading time isn't known.
	
	// The variables that determine the current opacity of the screen fade, and the value it is trying to
	// move towards given its current state. (This value is either 0 or 1)
	alpha = 0;
	alphaTarget = 1;
	
	// 
	playerX = 0;
	playerY = 0;
	drawPlayer = true;
	playerSurf = -1;
	
	// 
	targetX = 0;
	targetY = 0;

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
			if (GAME_CURRENT_STATE == GSTATE_PAUSED) {game_set_state(GAME_PREVIOUS_STATE, true);}
			if (surface_exists(playerSurf)){
				surface_free(playerSurf);
				playerSurf = noone;
				drawPlayer = false;
				playerX = 0;
				playerY = 0;
			}
		}
	}
	
	/// @description Code that should be placed into the "Draw" event of whatever object is controlling
	/// obj_screen_fade. 
	/// @param {Real}	cameraX		The camera's x position within the current room.
	/// @param {Real}	cameraY		The camera's y position within the current room.
	draw_gui = function(_cameraX, _cameraY){
		if (alpha == 0) {return;}
		var _alpha = alpha;
		draw_sprite_ext(spr_rectangle, 0, 0, 0, camera_get_width(), camera_get_height(), 0, fadeColor, _alpha);
		
		// 
		if (drawPlayer && !surface_exists(playerSurf)){
			// 
			var _x = 0;
			var _y = 0;
			var _spriteWidth = 0;
			var _spriteHeight = 0;
			var _offsetX = 0;
			var _offsetY = 0;
			with(PLAYER){
				_x = x;
				_y = y;
				_spriteWidth = sprite_get_width(sprite_index);
				_spriteHeight = sprite_get_height(sprite_index);
				_offsetX = sprite_get_xoffset(sprite_index) + SURFACE_OFFSET_X;
				_offsetY = sprite_get_yoffset(sprite_index) + SURFACE_OFFSET_Y;
			}
			
			// 
			playerSurf = surface_create(_spriteWidth + (SURFACE_OFFSET_X * 2), _spriteHeight + (SURFACE_OFFSET_Y * 2));
			surface_set_target(playerSurf);
			draw_clear_alpha(c_black, 0);
			with(PLAYER){
				draw_sprite_ext(sprite_index, imageIndex, _offsetX, _offsetY, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
				with(armCannon){
					if (!visible){break;}
					draw_sprite_ext(spr_samus_cannon0, imageIndex, x - _x + _offsetX, y - _y + _offsetY, image_xscale, 1, 0, c_white, 1);
				}
			}
			surface_reset_target();
		}
		draw_surface_ext(playerSurf, playerX, playerY, 1, 1, 0, HEX_WHITE, alpha);
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
		if (alpha != 0 && alphaTarget != 0) {return;}
		alpha = 0;
		alphaTarget = 1;
		
		fadeColor =		_fadeColor;
		fadeSpeed =		_fadeSpeed;
		fadeDuration =	_fadeDuration;
		drawPlayer =	_drawPlayer;
	}
	if (GAME_CURRENT_STATE != GSTATE_CUTSCENE) {game_set_state(GSTATE_PAUSED);}
}

#endregion
