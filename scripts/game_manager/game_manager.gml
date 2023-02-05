/// @description The game manager, which is responsible for handling the current global game state. That state
/// will affect all objects' current functionalities, as well as what the player is able to do (The player
/// cannot move the in-game player character during cutscenes, for example). On top of that, the manager will
/// calculate the delta time for the current frame, and also the total playtime.

#region Initializing any macros that are useful/related to the game manager

// A macro to simplify the look of the code whenever the game manager struct needs to be referenced.
#macro	GAME_MANAGER			global.gameManager

// Macros that allow easy referencing of the game's current and previous states, respectively.
#macro	GAME_CURRENT_STATE		global.gameManager.curState
#macro	GAME_PREVIOUS_STATE		global.gameManager.lastState

// The constant that will return the delta time value for the current frame to allow for proper 
// frame-independent physics calculations and value incrementing/decrementing.
#macro	DELTA_TIME				global.gameManager.deltaTime

// Constants that represent each of the game's global states; the priority of said states being determined
// by the highest value to the lowest value. This means "GSTATE_PAUSED" cannot be overwritten by another 
// state through normal means.
#macro	GSTATE_NONE				0
#macro	GSTATE_NORMAL			1
#macro	GSTATE_MENU				2
#macro	GSTATE_CUTSCENE			3
#macro	GSTATE_PAUSED			10

#endregion

#region Initializing enumerators that are useful/related to the game manager
#endregion

#region Initializing any globals that are useful/related to the game manager
#endregion

#region The main struct code for the game manager

global.gameManager = {
	// Stores the values for the current and previous global states for the game, respectively.
	curState :			GSTATE_NONE,
	lastState :			GSTATE_NONE,
	
	// The top variable will store the current value for delta timing to apply to all physics calculations
	// for processing the current game frame, and the target FPS determines how many times a value in processed
	// in a real-world section (Ex. Increasing a value by 2 every frame with a target FPS of 60 will result in
	// the value increasing by 120 units every second).
	deltaTime :			0,
	targetFPS :			60,
	
	// Variables that manage the game's current playtime; determined by instances where the "isTimerActive"
	// flag is set to true. Otherwise, the in-game time will not be added to the overall playtime for however
	// long the flag is false.
	curPlaytime :		0,
	playtimeMillis :	0.0,
	isTimerActive :		false,
	
	/// @description A function borrowing the same name as the event that it will be called in within the
	/// "obj_controller" object for the game. It will update the value of delta time for the new frame, and
	/// will update the player's in-game playtime if the tracking flag is enabled.
	begin_step : function(){
		deltaTime = (delta_time / 1000000) * targetFPS;
		
		// Update the current playtime if the timer hasn't been disabled by the current game state (The timer
		// will always be paused when the game is in a cutscene or completely paused).
		if (!isTimerActive) {return;}
		playtimeMillis += deltaTime;
		if (playtimeMillis >= 1.0){ // 1000 milliseconds have passed; add one second to the overall playtime.
			curPlaytime++;
			playtimeMillis -= 1.0;
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
			lastState = curState;
			curState = _state;
			isTimerActive = (curState < GSTATE_CUTSCENE);
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

#endregion