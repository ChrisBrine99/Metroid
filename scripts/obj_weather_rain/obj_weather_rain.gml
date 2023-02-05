/// @description Holds all of the code responsible for rendering the rain effect that can occur within the
/// game when necessary.

#region Initializing any macros that are useful/related to obj_weather_rain

// Macros used by the timers responsible for the thunder/lightning that can occur as an optional effect
// alongside the rain. The lightning can occur between a range of 5 and 20 seconds of real-world time.
#macro	MIN_LIGHTNING_INTERVAL		300
#macro	MAX_LIGHTNING_INTERVAL		1200

// Determines the number of flashes that occur for each lightning strike. Each strike will be spaced out
// be a number determined by a randeom value between the range values found in the macro pair below.
#macro	MIN_FLASHES					2
#macro	MAX_FLASHES					6

// The range in "frames" (One frame is 1/60th of a second) that the single-frame flashes will occur for
// each lightning strike. This is the time range between those flashes relative to the number of flashes
// for this lightning strike.
#macro	MIN_FLASH_BUFFER			6
#macro	MAX_FLASH_BUFFER			20

// Determines the total amount of raindrops that can exist simultaneously at any given time. This amount
// is any value between these two range constants.
#macro	MIN_RAINDROPS				95
#macro	MAX_RAINDROPS				130

// The range in "frames" (One frame = 1/60th of a second in the real world) that occurs between spawning
// each raindrop until the total amount of required raindrops have been created by the weather effect.
#macro	MIN_SPAWN_BUFFER			2
#macro	MAX_SPAWN_BUFFER			10

// A macro that refers to how far above the screen the starting y position of each raindrop will be. This
// value is also used to reset existing raindrops once they've hit their previous target y position and
// have spawned their raindrop splash.
#macro	RAIN_Y_START_OFFSET			32

#endregion

#region Initializing enumerators that are useful/related to obj_weather_rain
#endregion

#region Initializing any globals that are useful/related to obj_weather_rain
#endregion

#region The main object code for obj_weather_rain

/// @param {Bool} isLightningEnabled
function obj_weather_rain(_isLightningEnabled) constructor{
	// Much like Game Maker's own id variable for objects, this will store the unique ID value given to this
	// singleton, which is a value that is found in the "obj_controller_data" script with all the other
	// macros and functions for handling singleton objects.
	id = WEATHER_RAIN_ID;
	
	// A flag that determines if the lightning effect will be active alongside the standard rain effect.
	// This is determined by if the weather calls for lightning AND if the user has the accessibility setting
	// for enabling the flashes of lightning is toggled. Otherwise, no lightning flashes or thunder will
	// ever occur to minimize seizures.
	isLightningEnabled = _isLightningEnabled;
	
	// The two timers responsible for the optional thunder and lightning effects that occur alongside the
	// standard rain effect. There will be no point where both of these timers have values greater than
	// zero at the same time; it should always be one or the other.
	lightningTimer = random_range(MIN_LIGHTNING_INTERVAL, MAX_LIGHTNING_INTERVAL);
	thunderTimer = 0;
	
	// The variables needed for the lightning flash effect. The first determines how many flashes will 
	// occur for a given lightning strike, the second variable being the short duration between the flashes.
	// Finally, the last variable determines the transparency level for teh current flash of lightning.
	totalFlashes = 0;
	flashBuffer = 0;
	flashAlpha = 0;
	
	// Stores all of the instances of raindrops that currently exist for the weather effect. The variable
	// "totalRaindrops" determines how many raindrops can exist within the ds_list at once; determined by
	// randomly choosing a value between the two set minimum and maximum range values.
	raindrops = ds_list_create();
	totalRaindrops = irandom_range(MIN_RAINDROPS, MAX_RAINDROPS);
	
	// Determines the gap in "frames" (One frame being 1/60th of a real-world second) that space out the
	// spawning of rain droplets; making the rain smoothly begin from no raindrops to a gradual screen full
	// of them.
	spawnBuffer = 0;
	
	// A simple toggle that causes the rain weather effect to slowly end after a call to the function 
	// "effect_end_weather_rain" by slowly decreasing the amount of raindrops that exist at once until that
	// number reaches zero. At that point, the struct will free itself from memory.
	isEnding = false;
	
	// A simple flag that causes the code to ignore rendering the raindrops; waiting only until the rain
	// sound fades out in order to stop that sound (Which deletes the instance of that sound within GML's
	// internal data) before deleting this struct.
	skipEndingAnimation = false;
	
	// Holds all of the currently existing instances of raindrop splashes that currently exist in the world.
	// These splashes are created by raindrops hitting their "target value" on the y-axis, which resets
	// their position to somewhere on the top edge of the screen.
	splashes = ds_list_create();
	
	// The variables that are responsible for handling the sound effects that can occur alongside the rain
	// effect. The "soundData" variable will store the data for the loaded sound effects--which are stored
	// as buffers--and the other two variables will store the sound instance that plays for the rain loop
	// and thunder, respectively.
	soundData = ds_map_create();
	rainSound = NO_SOUND;
	thunderSound = NO_SOUND;
	
	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_weather_rain. In short, it will handle the creation of raindrops, as well as the updating of
	/// their vertical positions and the animations for each currently existing raindrop splash. 
	step = function(){
		// Code for when the weather effect is ending. It will wait until all raindrop objects have been
		// removed from the list that manages them and that the sound effect for the rain has completely
		// faded out. At that point, this struct will destroy itself.
		var _length = ds_list_size(raindrops);
		if (isEnding && (_length == 0 || skipEndingAnimation)  && audio_sound_get_gain(rainSound) == 0){
			audio_stop_sound(rainSound);
			cleanup(); // Don't forget to clean up the data structures contained in this struct.
			delete WEATHER_RAIN;
			WEATHER_RAIN = noone;
			return;
		}
		
		// The chunk of code responsible for spawning in all of the raindrop instances that are required
		// for the effect to actually look like rain. It will count down the buffer timer's value until it
		// reaches zero, where another rain struct will be added to the list of total raindrops.
		if (_length < totalRaindrops && !isEnding){
			spawnBuffer -= DELTA_TIME;
			if (spawnBuffer <= 0){
				spawnBuffer = random_range(MIN_SPAWN_BUFFER, MAX_SPAWN_BUFFER);
				initialize_raindrop();
			}
		}
		
		// Store some important camera values (as well as the currently calculated value for delta time)
		// so that there aren't constant jumps between the camera's scope and the current raindrop's scope,
		// which will slow down the overall codes execution when there are 100 or so raindrop instances.
		var _cameraX, _cameraY, _cameraWidth, _cameraHeight, _deltaTime;
		_cameraX = CAMERA.x;
		_cameraY = CAMERA.y;
		_cameraWidth = camera_get_width();
		_cameraHeight = camera_get_height();
		_deltaTime = DELTA_TIME;
		
		// Loop through all of the currently existing raindrop instances, updating their positions; each x
		// position being updated such that it wraps along the screen as the camera moves horizontally, and
		// each y position being updated if the raindrop's target y position has been reached. (That position
		// is where the raindrop's splash effect will be spawned)
		var _raindrops, _splashes, _isEnding, _x, _y, _alpha;
		_raindrops = raindrops;	// Store references to some of the main struct's variables for faster reference in the loop.
		_splashes = splashes;
		_isEnding = isEnding;
		for (var i = 0; i < _length; i++){
			with(raindrops[| i]){
				// Wraps the raindrops that end up outside of the current horizontal bounds of the camera's
				// current view to the right and left sides of the screen from the other, respectively.
				if (x < _cameraX)						{x += _cameraWidth;}
				else if (x > _cameraX + _cameraWidth)	{x -= _cameraWidth;}
				
				// Moving the raindrops vertically through whole values to prevent any sub-pixel movement,
				// which could cause issues while rendering the raindrop given the game's low resolution.
				// The distance from the bottom of the screen that the raindrop's target is will affect
				// how fast it moves towards said target position to align with the 2.5D perspective 
				// that the game's art is going for.
				var _targetToCamRatio = (targetY - _cameraY) / _cameraHeight;
				fractionY += ((vspd * _targetToCamRatio) + 2) * _deltaTime;
				if (fractionY >= 1){
					y += fractionY;
					fractionY -= fractionY;
					
					// If the target position has been hit by the raindrop OR the raindrop goes well below
					// the bottom bounds of the game's current camera view. When this happens, the raindrop
					// splash will be created at the position of the raindrop.
					if (y >= targetY){
						// Pass over the raindrop's coordinates in the room, and the alpha value for the
						// raindrop so the splash will match the characteristics of the raindrop it came
						// from. 
						_x = x;
						_y = y;
						_alpha = alpha;
						ds_list_add(_splashes, {
							x :				_x,
							y :				_y,
							startAlpha :	_alpha,
							curAlpha :		_alpha,
							imgIndex :		0,
						});
						
						// When the weather effect is toggled to end, there will be a 33% chance of the 
						// raindrop will despawn instead of being reset to the top of the screen. The only
						// exception to this is when there are less than 10 raindrops remaining on screen;
						// when that happens the raindrop will always despawn no matter what.
						if (_isEnding && (_length <= 10 || irandom_range(0, 99) <= 33)){
							delete _raindrops[| i];
							ds_list_delete(_raindrops, i);
							_length--;
							i--;
							continue; // Skips over the position/target resetting code
						}
						
						// In order to make the rain seem random and nor repetitive, the horiztonal position,
						// and target y position will be randomly set each time the raindrop hits its target
						// or goes too far below the screen. The y position is always set to be four pixels
						// above the camera's top view boundary, however.
						x = _cameraX + irandom_range(2, _cameraWidth - 2);
						y = _cameraY - RAIN_Y_START_OFFSET;
						targetY = y + irandom_range(32, _cameraHeight + 64);
					}
				}
			}
		}
		
		// Loop through all of the currently existing raindrop splashes, which is as simple as adding to
		// the value that animates the splash. Once that animation value exceeds the total number of images
		// for the animation, the splash will be deleted. Also, the alpha will be faded out at that speed
		// to make the splash effect smoother.
		_length = ds_list_size(splashes);
		for (var j = 0; j < _length; j++){
			with(splashes[| j]){
				curAlpha -= (startAlpha / 20) * _deltaTime;
				imgIndex += 0.6 * _deltaTime;
				if (imgIndex >= 3){
					delete _splashes[| j];
					ds_list_delete(_splashes, j);
					_length--;
					j--;
				}
			}
		}
		
		// If the lightning effect happens to be enabled by the mix of the accessibility setting for it
		// being toggled to allow lightning, and the weather effect calling for lightning and thunder in
		// the current area, the logic for the effect (Aside from rendering the effect) is all handled here.
		if (isLightningEnabled){
			// Whenever the thunder timer is greater than a value of zero, it will count it down each frame
			// until it reaches zero. After that point, the lightning timer is reset and the sound effect
			// for the thunder is set up and played.
			if (thunderTimer > 0){
				thunderTimer -= DELTA_TIME;
				if (thunderTimer <= 0){
					lightningTimer = random_range(MIN_LIGHTNING_INTERVAL, MAX_LIGHTNING_INTERVAL);
					
					// Play the thunder sound effect; the one that is played being determined by random
					// number generation alongside randomly altering the pitch and volume of the sound
					// to make each one as unique as possible despite there being only 5 unique sounds
					// to choose from.
					//var _pitch, _volume, _soundKey;
					//_pitch = 1 + random_range(-0.25, 0.25);
					//_volume = SOUND_VOLUME * random_range(0.5, 1);
					//_soundKey = "thunder_" + string(irandom_range(1, 5));
					//thunderSound = audio_play_sound_ext(soundData[? _soundKey][AUDIO_DATA], 100, _volume, _pitch);
				}
				
				// Until the thunder sound effect has played, the lightning timer will be paused; stopping
				// any more flashes from occuring until the the thunder timer is at zero again.
				return;
			}
			
			// When possible, the lightning timer is count down on every frame until it reaches a value of
			// zero. When that point is reached, the number of flashes for the current lightning strike is
			// determines, and the accompanying thunder sound effect that comes after said flashes. Until
			// that effect has been completed, this timer will be paused.
			lightningTimer -= DELTA_TIME;
			if (lightningTimer <= 0){
				totalFlashes = irandom_range(MIN_FLASHES, MAX_FLASHES);
				thunderTimer = 60 + random(30);
			}
		}
	}
	
	/// @description Code that should be placed into the "Draw End" event of whatever object is controlling
	/// obj_weather_rain. In short, it will render all existing instances of raindrops and raindrop splash
	/// effects to the screen.
	draw_end = function(){
		// Ignore rendering if the ending animation was set to be skipped over.
		if (isEnding && skipEndingAnimation) {return;}
		
		// The splash effects are rendered first in their order of creation within the list. If they were
		// rendered after the raindrops, the splashes would appear above drops that could potentially pass
		// through the region that a splash occupies, which isn't correct.
		var _length = ds_list_size(splashes);
		for (var j = 0; j < _length; j++){
			with(splashes[| j]) {draw_sprite_ext(spr_raindrop_land, imgIndex, x, y, 1, 1, 0, c_white, curAlpha);}
		}
		
		// After all the raindrop splashes have been drawn to the screen, the raindrops themselves will be
		// drawn at each of their repesctive positions and transparency values. The distance that the drop's
		// target position is relative to the camera's bottom edge will determine how it is scaled vertically
		// when drawn on screen; adhering to the 2.5D perspective of the game.
		_length = ds_list_size(raindrops);
		var _cameraY, _cameraHeight, _targetToCamRatio, _raindropBlendColor;
		_cameraY = CAMERA.y;
		_cameraHeight = CAM_HEIGHT;
		for (var i = 0; i < _length; i++){
			with(raindrops[| i]){
				_targetToCamRatio = (targetY - _cameraY) / _cameraHeight;
				_raindropBlendColor = min(190 + (_targetToCamRatio * 65), 255);
				draw_sprite_ext(spr_raindrop, 0, x, y, 1, 0.5 + (_targetToCamRatio * 1.5), 0, make_color_rgb(_raindropBlendColor, _raindropBlendColor, _raindropBlendColor), alpha);
			}
		}
	}
	
	/// @description Code that should be placed into the "Draw GUIBegin" event of whatever object is controlling
	/// obj_weather_rain. It is only responsible for displaying the lightning flashes to the screen above
	/// the rest of the game's graphics and counting down the timer to do so.
	draw_gui_begin = function(){
		if (isLightningEnabled && (totalFlashes > 0 || flashAlpha > 0)){
			flashBuffer -= DELTA_TIME;
			if (flashBuffer <= 0 && totalFlashes > 0){
				flashBuffer = random_range(MIN_FLASH_BUFFER, MAX_FLASH_BUFFER);
				flashAlpha = 1; // Reset the alpha to maximum every "flash".
				totalFlashes--;
			}
			
			// Draw the white flash that occurs for each lightning strike. It will start at an alpha level
			// of one before being slowly faded out back to complete transparency; making for a decent
			// effect for lightning strikes.
			draw_sprite_ext(spr_rectangle, 0, 0, 0, CAM_WIDTH, CAM_HEIGHT, 0, c_white, flashAlpha);
			flashAlpha = value_set_linear(flashAlpha, 0, 0.075);
		}
	}
	
	/// @description Code that should be placed into the "Cleanup" event of whatever object is controlling
	/// obj_weather_rain. In short, ir removes any data from memory that isn't automatically cleaned up
	/// by Game Maker's default garbage collection code for objects, arrays, and things like that.
	cleanup = function(){
		// Delete any raindrop instances that may still currently exist when this weather effect has been
		// destroyed by the object that manages it. After that, the list that held all thos instances is
		// destroyed to prevents any further memory leaks.
		var _length = ds_list_size(raindrops);
		for (var i = 0; i < _length; i++) {delete raindrops[| i];}
		ds_list_destroy(raindrops);
		
		// Much like above, instances that may still exist upon this struct's deletion will be cleaned up
		// to prevent memory leaks. However, this one will handle cleaning up the list that manages the
		// existing instances of raindrop splashes.
		_length = ds_list_size(splashes);
		for (var j = 0; j < _length; j++) {delete splashes[| j];}
		ds_list_destroy(splashes);
		
		// Clean up all of the buffers created by loading in external sound effects; deleting their audio
		// buffers as well to ensure that no memory is left allocated after this struct is deleted from
		// memory. After all the buffer data has been cleared out, the map that once stored that data is
		// cleared from memotry as well.
		var _key = ds_map_find_first(soundData);
		while(!is_undefined(_key)){
			audio_free_buffer_sound(soundData[? _key][AUDIO_DATA]);
			buffer_delete(soundData[? _key][AUDIO_BUFFER]);
			_key = ds_map_find_next(soundData, _key);
		}
		ds_map_destroy(soundData);
	}
	
	/// @description The function that is called at the end of this struct (This is required since it won't
	/// know what this function is until it has been read by the code; reading it from top to bottom instead
	/// of out-of-order like Java can do.) in order to load in all of the external sound effects that are
	/// used alongside the rest of the rain effect.
	load_sound_effects = function(){
		// Add the sound that will loop for the duration of the rain weather effect into memory and then
		// begin its playing; starting the volume at zero until the code elsewhere would fade it in along
		// with the animation or skipping of the animation, respectively.
		ds_map_add(soundData, "rain", audio_load_sound_wav("sounds/rain/rain_loop", "rain", 32000, audio_stereo));
		//rainSound = audio_play_sound_ext(soundData[? "rain"].audioBuffer, 0, 1, 1000, true);
		
		// Since all of the files used for the different thunder sounds all share the same template for
		// their naming scheme, sample rate, and audio channel settings; they will be added in a loop to 
		// shorten and simplify the code.
		var _string; // Created outside of the loop since it will be used in it.
		for (var i = 1; i < 6; i++){ // There are a total of five different sound effects for the thunder, so loop five times.
			_string = "thunder_" + string(i);
			ds_map_add(soundData, _string, audio_load_sound_wav("sounds/rain/" + _string, _string, 32000, audio_mono));
		}
	}
	
	/// @description A simple function that adds a new raindrop instance struct to the list of raindrops
	/// that is currently being managed by the weather effect handling struct. (That struct being the one
	/// that contains this function)
	initialize_raindrop = function(){
		var _startY = CAMERA.y - RAIN_Y_START_OFFSET;
		ds_list_add(raindrops, {
			x :			CAMERA.x + irandom_range(2, camera_get_width() - 2),
			y :			_startY, // All raindrops will initially spawn at the same Y offset.
			fractionY : 0, // Prevents fractional vertical position values.
			targetY :	_startY + irandom_range(32, camera_get_height() + 64),
			vspd :		4 + random(1.25), // Makes each raindrop have a slightly offset vertical velocity.
			alpha :		random_range(0.5, 1),
		});
	}
	
	// This function must always be called upon creation of the rain effect struct. Otherwise, the sound
	// effects will not be properly loaded into memory and not be playable.
	load_sound_effects();
}

#endregion

#region Global functions related to obj_weather_rain

/// @description Creates the struct that is responsible for managing the rain/storm weather effect. Optionally,
/// the starting animation that slowly adds more and more raindrops as the sound for the rain smoothly fades
/// in can be skipped if an area already has rain, for example. Otherwise, the starting animation will play 
/// out as it normally does.
/// @param {Bool}	skipStartingAnimation
/// @param {Bool}	enableLightning
function effect_create_weather_rain(_skipStartingAnimation, _enableLightning){
	if (WEATHER_RAIN == noone){
		WEATHER_RAIN = new obj_weather_rain(_enableLightning);
		with(WEATHER_RAIN){
			audio_sound_gain(rainSound, SOUND_VOLUME, 6500 - (5500 * _skipStartingAnimation));
			// Creates all the raindrops at once; placing them wherever along, so that they all don't
			// start at the same position and basically all fall uniformly along the screen at first,
			if (_skipStartingAnimation){
				for (var i = 0; i < totalRaindrops; i++){
					initialize_raindrop(); // Create the new instance. Then, offset its starting position.
					with(raindrops[| i]) {y += irandom(y - targetY - 16);}
				}
			}
		}
	}
}

/// @description Calls to begin the deletion of the rain effect struct. It will slowly remove raindrops
/// until none remain in the struct's ds_list for managing all this raindrop instances. Also, the sound
/// effect for the rain will be set to slowly fade away here. (Over the span of 3.5 real-world seconds)
/// Optionally, the ending animation can be skipped over; having this struct clean itself up and delete
/// itself simply when the rain sound fully fades out. (The fade out being shorter when the animation is
/// skipped over)
/// @param {Bool}	skipEndingAnimation
function effect_end_weather_rain(_skipEndingAnimation){
	with(WEATHER_RAIN){
		audio_sound_gain(rainSound, 0, 3500 - (3000 * _skipEndingAnimation));
		skipEndingAnimation = _skipEndingAnimation;
		isEnding = true;
	}
}

#endregion