#region Initializing any macros that are useful/related to the game manager

// ------------------------------------------------------------------------------------------------------- //
//	A macro to simplify the look of the code whenever the game manager struct needs to be referenced.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GAME_MANAGER			global.gameManager

// ------------------------------------------------------------------------------------------------------- //
//	Macros that allow easy referencing of the game's current and previous states, respectively.			   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GAME_CURRENT_STATE		global.gameManager.curState
#macro	GAME_PREVIOUS_STATE		global.gameManager.lastState

// ------------------------------------------------------------------------------------------------------- //
//	The constant that will return the delta time value for the current frame to allow for proper		   //
//	frame-independent physics calculations and value incrementing/decrementing.							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DELTA_TIME				global.gameManager.deltaTime

// ------------------------------------------------------------------------------------------------------- //
//	The maximum possible value that delta time will be able to reach. This means that the lowest possible  //
//	FPS for the game's physics to work in a frame-independent manner is the game's target FPS divided by   //
//	whatever this number is set to.																		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DELTA_LIMIT				4.0

// ------------------------------------------------------------------------------------------------------- //
//	Determines at what frame rate the value for delta time will be around 1.0 units. All physics should	   //
//	be based on this target FPS value.																	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	TARGET_FPS				60.0

// ------------------------------------------------------------------------------------------------------- //
//	Constants that represent each of the game's global states; the priority of said states being		   //
//	determined by the highest value to the lowest value. This means "GSTATE_PAUSED" cannot be overwritten  //
//	by another state through normal means.																   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GSTATE_NONE				0x00
#macro	GSTATE_NORMAL			0x01
#macro	GSTATE_MENU				0x02
#macro	GSTATE_CUTSCENE			0x03
#macro	GSTATE_PAUSED			0x10

#endregion

#region Initializing enumerators that are useful/related to the game manager
#endregion

#region Initializing any globals that are useful/related to the game manager
#endregion

#region The main struct code for the game manager

global.gameManager = {
	// Stores the values for the current and previous global states for the game, respectively.
	curState			: GSTATE_NONE,
	lastState			: GSTATE_NONE,
	
	// Stores the current "delta time" which represents the amount of time in seconds between in-game frames.
	// One unit within the game's physics is equal to 1/60th of a real-world second; meaning physics should be
	// calculated as if the game is running at 60 frames per second.
	deltaTime			: 0.0,
	
	// Stores the current amount of time in seconds and milliseconds, resepctively. Differs from playtime timer
	// which only increments when it is active. Total time is always incrementing as long as the "targetFPS"
	// value isn't set to 0.0.
	totalTime			: 0,
	totalTimeMillis		: 0.0,
	
	// Variables that manage the game's current playtime; determined by instances where the "isTimerActive"
	// flag is set to true. Otherwise, the in-game time will not be added to the overall playtime for however
	// long the flag is false.
	curPlaytime			: 0,
	playtimeMillis		: 0.0,
	isTimerActive		: false,
	
	/// @description A function borrowing the same name as the event that it will be called in within the
	/// "obj_controller" object for the game. It will update the value of delta time for the new frame, and
	/// will update the player's in-game playtime if the tracking flag is enabled.
	begin_step : function(){
		deltaTime = (delta_time / 1000000.0) * TARGET_FPS;
		// Limit delta time to framerates of 15 and above to avoid potential physics issues.
		if (deltaTime >= DELTA_LIMIT)
			deltaTime = DELTA_LIMIT;
		
		// Update the total playtime value regardless of if the in-game time is ticking up or not.
		var _curMillisecondDelta = deltaTime / TARGET_FPS;
		totalTimeMillis += _curMillisecondDelta;
		if (totalTimeMillis >= 1.0){
			totalTimeMillis -= 1.0;
			totalTime++;
		}
		
		// Only continue through this function is the game's playtime timer is set to active. Otheriwse, the
		// function will exit out here.
		if (!isTimerActive) 
			return;
			
		// The playtime counter is enabled, so it will be updated in much the same way as the program's total 
		// playtime counter logic is handled.
		playtimeMillis += _curMillisecondDelta;
		if (playtimeMillis >= 1.0){
			playtimeMillis -= 1.0;
			curPlaytime++;
		}
	}
}

#endregion

#region Global functions related to the game manager

/// @description Assigns a new state to the entire game. This state will be used to determine the functionality
/// of all objects, UI, play input capabilities, and so on.
/// @param {Real}	state			The new state value. If it is a lower priority than the current state, no change will occur.
/// @param {Bool}	highPriority	A value of "true" will overwrite the current state regardless of the new state's priority.
function game_set_state(_state, _highPriority = false){
	with(GAME_MANAGER){
		if ((!_highPriority && _state > curState) || _highPriority){ 
			lastState		= curState;
			curState		= _state;
			isTimerActive	= (_state < GSTATE_CUTSCENE);
		}
	}
}

/// @description Returns the current amount of playtime the player has accumulated over the course of their
/// gameplay. It is a value that is unique to each save file.
/// @param {Bool} includeMillis		Include the current milliseconds as the decimal value alongside the whole number for seconds.
function game_get_playtime(_includeMillis){
	with(GAME_MANAGER) {return (_includeMillis ? (curPlaytime + millisTimer) : curPlaytime);}
	return 0;
}

/// @description Returns the name and numerical value for the state value that was provided for this function's
/// argument. Can be used to get the current or previous game state values, or just the name of a specific
/// state that is independent of those two values for whatever reason.
/// @param {Real}	state	The state to return the name and numerical value of.
function game_state_get_name(_state){
	with(GAME_MANAGER){
		switch(_state){
			default:
			case GSTATE_NONE:		return "NoState ("	+ string(_state) + ")";
			case GSTATE_NORMAL:		return "InGame ("	+ string(_state) + ")";
			case GSTATE_MENU:		return "InMenu ("	+ string(_state) + ")";
			case GSTATE_CUTSCENE:	return "Cutscene (" + string(_state) + ")";
			case GSTATE_PAUSED:		return "Paused ("	+ string(_state) + ")";
		}
	}
	return "";
}

#endregion