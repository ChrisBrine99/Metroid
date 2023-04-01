#region Initializing any macros that are useful/related to obj_console

// 
#macro	CMD_TEST				"test"

// 
#macro	DRAW_CURSOR				28
#macro	FIRST_BACKSPACE			29
#macro	FIRST_CURSOR_MOVE		30
#macro	CONSOLE_ACTIVE			31

//
#macro	CAN_DRAW_CURSOR			(stateFlags & (1 << DRAW_CURSOR) != 0)
#macro	IS_FIRST_BACKSPACE		(stateFlags & (1 << FIRST_BACKSPACE) != 0)
#macro	IS_FIRST_CURSOR_MOVE	(stateFlags & (1 << FIRST_CURSOR_MOVE) != 0)
#macro	IS_CONSOLE_ACTIVE		(stateFlags & (1 << CONSOLE_ACTIVE) != 0)

// 
#macro	FIRST_BSPACE_INTERVAL	30.0
#macro	BSPACE_INTERVAL			1.75

// 
#macro	FIRST_MOVE_INTERVAL		20.0
#macro	CURSOR_MOVE_INTERVAL	1.25
#macro	CURSOR_FLASH_INTERVAL	15.0

// 
#macro	COMMAND_NAME			0
#macro	COMMAND_FUNCTION		1

// 
#macro	TYPE_REAL				5000
#macro	TYPE_BOOL				5001
#macro	TYPE_STRING				5002

#endregion

#region Initializing any globals that are useful/related to obj_console
#endregion

#region The main object code for obj_console

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_console(_index) : base_struct(_index) constructor{
	// Stores whatever was typed by the used, which is then processed once they hit the enter key. It can be used
	// to get the value of an event flag, set or reset flags, create objects, destroy objects, and much more.
	command = "";
	
	// 
	history = ds_list_create();
	
	// 
	stateFlags = (1 << FIRST_BACKSPACE) | (1 << FIRST_CURSOR_MOVE);
	
	// 
	cursorPos = 1;
	
	// 
	backspaceTimer = 0.0;
	cursorMoveTimer = 0.0;
	cursorTimer = 0.0;
	
	// 
	validCommands = [];
	totalCommands = 0;
	
	// 
	entityStates = ds_map_create();
	
	// 
	gameCurState = GSTATE_NONE;
	gamePrevState = GSTATE_NONE;
	
	/// @description
	cleanup = function(){
		ds_map_destroy(entityStates);
	}
	
	/// @description 
	end_step = function(){
		// 
		if (!IS_CONSOLE_ACTIVE){
			if (keyboard_check_pressed(vk_insert)){
				var _curState, _nextState, _lastState;
				var _entityStates = entityStates;
				var _key = ds_map_find_first(entityStates);
				with(par_dynamic_entity){
					if (curState == NO_STATE) {continue;}
					_curState = curState;
					_nextState = nextState;
					_lastState = lastState;
					ds_map_add(_entityStates, id, {
						curState	: _curState,
						nextState	: _nextState,
						lastState	: _lastState,
					});
					stateFlags |= (1 << FREEZE_ANIMATION);
					curState	= NO_STATE;
					nextState	= NO_STATE;
					lastState	= NO_STATE;
				}
				
				gameCurState = GAME_CURRENT_STATE;
				gamePrevState = GAME_PREVIOUS_STATE;
				game_set_state(GSTATE_PAUSED, true);
				stateFlags |= (1 << CONSOLE_ACTIVE);
				keyboard_lastchar = "";
			}
			return;
		}
		
		// 
		if (keyboard_check_pressed(vk_insert)){
			var _stateData, _curState, _nextState, _lastState;
			var _key = ds_map_find_first(entityStates);
			while(!is_undefined(_key)){
				_stateData = entityStates[? _key];
				with(_stateData){
					_curState	= curState;
					_nextState	= nextState;
					_lastState	= lastState;
				}
				
				with(_key){
					stateFlags &= ~(1 << FREEZE_ANIMATION);
					curState	= _curState;
					nextState	= _nextState;
					lastState	= _lastState;
				}
				_key = ds_map_find_next(entityStates, _key);
				delete _stateData;
			}
			ds_map_clear(entityStates);
			
			game_set_state(GAME_PREVIOUS_STATE, true);
			stateFlags &= ~((1 << CONSOLE_ACTIVE) | (1 << DRAW_CURSOR));
			stateFlags |= ((1 << FIRST_BACKSPACE) | (1 << FIRST_CURSOR_MOVE));
			backspaceTimer = 0.0;
			cursorMoveTimer = 0.0;
			cursorTimer = 0.0;
			cursorPos = 1;
			command = "";
			return;
		}
		
		// 
		cursorTimer += DELTA_TIME;
		if (cursorTimer >= CURSOR_FLASH_INTERVAL){
			if (CAN_DRAW_CURSOR) {stateFlags &= ~(1 << DRAW_CURSOR);}
			else				 {stateFlags |= (1 << DRAW_CURSOR);}
			cursorTimer = 0.0;
		}
		
		// 
		if (keyboard_check_pressed(vk_enter)){
			parse_current_command(command);
			keyboard_lastchar = "";
			command = "";
			return;
		}
		
		// 
		if (keyboard_check(vk_backspace) && cursorPos > 1){
			backspaceTimer -= DELTA_TIME;
			if (backspaceTimer <= 0.0){
				cursorPos--;
				command = string_delete(command, cursorPos, 1);
				if (IS_FIRST_BACKSPACE){ // First backspace; longer duration before next character is deleted. 
					backspaceTimer = FIRST_BSPACE_INTERVAL;
					stateFlags &= ~(1 << FIRST_BACKSPACE);
				} else{ // All subsequent backspaces, which are much faster than the initial one.
					backspaceTimer = BSPACE_INTERVAL;
				}
			}
			keyboard_lastchar = "";
			return;
		} else{ // Reset backspace variables to enable the longer first deletion interval again.
			stateFlags |= (1 << FIRST_BACKSPACE);
			backspaceTimer = 0.0;
		}
		
		// 
		var _movement = keyboard_check(vk_right) - keyboard_check(vk_left);
		if (_movement != 0){
			cursorMoveTimer -= DELTA_TIME;
			if (cursorMoveTimer <= 0.0){
				if (_movement == 1 && cursorPos <= string_length(command))	{cursorPos++;} 
				else if (_movement == -1 && cursorPos > 1)					{cursorPos--;}
				
				if (IS_FIRST_CURSOR_MOVE){ // Like the backspace code; the first movement will always have a longer duration until the next movement.
					stateFlags &= ~(1 << FIRST_CURSOR_MOVE);
					cursorMoveTimer = FIRST_MOVE_INTERVAL;
				} else{ // All subsequent cursor movements will move at a quick and regular interval.
					cursorMoveTimer = CURSOR_MOVE_INTERVAL;
				}
			}
			keyboard_lastchar = "";
			return;
		} else{ // 
			stateFlags |= (1 << FIRST_CURSOR_MOVE);
			cursorMoveTimer = 0.0;
		}
		
		// Adding the next key that was pressed at the end of the current string of command text. The variable
		// that stored the character that we added (A built-in GML variable) is cleared to prevent potential
		// duplication of a character when a non-character key is pressed.
		if (keyboard_lastkey != vk_nokey && keyboard_lastkey != vk_shift && keyboard_lastchar != ""){
			command = string_insert(keyboard_lastchar, command, cursorPos);
			keyboard_lastkey = vk_nokey;
			keyboard_lastchar = "";
			cursorPos++;
		}
	}
	
	/// @description 
	draw_gui = function(){
		if (!IS_CONSOLE_ACTIVE) {return;}
		
		var _cameraID = CAMERA.camera;
		var _camWidth = camera_get_view_width(_cameraID);
		var _camHeight = camera_get_view_height(_cameraID);
		draw_sprite_ext(spr_rectangle, 0, 0, 0, _camWidth, _camHeight, 0, HEX_BLACK, 0.75);
		draw_sprite_ext(spr_rectangle, 0, 0, 163, _camWidth, 10, 0, HEX_DARK_GRAY, 0.5);
		
		shader_set_outline(font_gui_small, RGB_GRAY);
		draw_text_outline(3, 165, "> ", HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, 1);
		draw_text_outline(10, 165, command, HEX_WHITE, RGB_GRAY, 1);
		shader_reset();
		
		if (CAN_DRAW_CURSOR){
			var _cursorX = string_width(string_copy(command, 1, cursorPos - 1)) + 1;
			draw_sprite_ext(spr_rectangle, 0, 8 + _cursorX, 164, 1, 8, 0, HEX_LIGHT_YELLOW, 1);
		}
	}
	
	/// @description Attempts to parse out the command data that was typed in by the user. It will find the
	/// required function and any arguments that the function may require. Any errors within this process will
	/// display a failure message in order to let the user know where they messed up in the typed command.
	/// @param {String}	command		The data that was typed into the console command line by the user.
	parse_current_command = function(_command){
		var _funcString = _command;
		var _firstSpace = string_pos(CHAR_SPACE, _funcString);
		if (_firstSpace > 0) {_funcString = string_copy(_command, 1, _firstSpace - 1);}
		
		// Attempt to get a valid function's data out of the first chunk of the string, which is used as the
		// name of the function to retrieve the data of. Any data after a space (If there was one used for the
		// function in question) is ignored for this function. If no valid data is found, exit early and show
		// the user an error message within the console's history window.
		var _index = get_function_from_string(string_lower(_funcString));
		if (_index == -1){
			show_debug_message("Function couldn't be found!");
			return;
		}
		
		// After a valid function is found and its data has been retrieved, a check will be performed to see
		// if the function requires arguments in order to function. If so, those functions are parsed out of
		// the remaining string data after the first space in the command string data. Otherwise, just call
		// the function that the user wanted to execute.
		var _data = validCommands[_index];
		if (array_length(_data) > 2){ // Argument types occupy the 3rd index onward.
			var _argString = string_copy(_command, _firstSpace + 1, string_length(_command));
			var _datatypes = []; // Must be initialized before the argument datatypes are copied over to it.
			array_copy(_datatypes, 0, _data, 2, array_length(_data) - 2);
			
			var _arguments = get_arguments_from_string(_argString, _datatypes);
			if (array_length(_arguments) != array_length(_datatypes)){
				show_debug_message("Argument Error: \n" + string(_datatypes) + "\n" + string(_arguments));
				return;
			}
			script_execute_ext(method_get_index(_data[COMMAND_FUNCTION]), _arguments);
		} else{ // Simply call the requested function.
			_data[COMMAND_FUNCTION]();
		}
	}
	
	/// @description Takes in the first chunk of the command's string (Whatever was typed before the first
	/// space--if there even was a space to begin with) and returns the array index within the function data
	/// that the function requires in order to properly parse the string and use that data to execute it.
	/// @param {String}	string	The string that will be treated as the function name to search for.
	get_function_from_string = function(_string){
		var _index;
		for (var i = 0; i < totalCommands * 0.5; i++){
			if (validCommands[i][COMMAND_NAME] == _string)		{return i;}
			_index = max(totalCommands - 1 - i, 0); // Prevents negative index values from being accessed.
			if (validCommands[_index][COMMAND_NAME] == _string)	{return _index;}
		}
		return -1;
	}
	
	/// @description Takes in the remainder of the "command" string and attempts to parse out the required
	/// arguments for the function that the user is attempting to call. A failure of this function's execution
	/// will return an array that doesn't equal in length to the number of arguments required by the function.
	/// @param {String}			string		Contains all of the function's required arguments; separated by spaces.
	/// @param {Array<Real>}	datatypes	A copy of the datatypes required by the function, which determines how each argument is parsed.
	get_arguments_from_string = function(_string, _datatypes){
		var _argString, _argStringExt;
		var _length = array_length(_datatypes);
		var _currentArg = 0;
		var _arguments = [];
		var _spacePos = 1;
		var _index = 1;
		while(_currentArg < _length){
			// Grab the position of the next space between the arguments OR the last character's index value
			// due to it not having anymore arguments so the copying of the substring works as it should
			// (Using "string_pos_ext" for both scenarios would result in "_spacePos" being set to 0 for 
			// the final argument due to no space character existing past that last argument).
			if (_currentArg >= _length - 1)	{_spacePos = string_length(_string) + 1;}
			else							{_spacePos = string_pos_ext(CHAR_SPACE, _string, _index);}
			
			// Parse the string that is pulled from the arguments depending on the datatype required by the 
			// function that is set to be called after this function.
			_argString = string_copy(_string, _index, _spacePos - _index);
			switch(_datatypes[_currentArg]){
				case TYPE_REAL: // Convert the string argument into a number and place it into the argument array.
					_arguments[array_length(_arguments)] = real(_argString);
					break;
				case TYPE_BOOL: // Replace the "true" or "false" string with their GML constant equivalents.
					_argStringExt = string_lower(_argString);
					if (_argStringExt == "true")		{_arguments[array_length(_arguments)] = true;}
					else if (_argStringExt == "false")	{_arguments[array_length(_arguments)] = false;}
					break;
				case TYPE_STRING: // The argument is already a string; simply place it into the argument array.
					_arguments[array_length(_arguments)] = _argString;
					break;
			}
			_index = _spacePos + 1;
			_currentArg++;
		}
		return _arguments;
	}
	
	/// @description 
	/// @param {String}	string
	history_add_line = function(_string){
		
	}
	
	/// @description A very simple command that will execute the game's end; closing the application and 
	/// running all existing objects "cleanup" functions to clear any manually allocated memory in the game.
	cmd_exit_game = function(){
		game_end();
	}
	
	/// @description A simple function that displays the game's current state and its previous state (Whatever 
	/// they were set to prior to the console being opened due to it setting the current state to "paused").
	cmd_game_state = function(){
		// TODO -- Display the game's state within the console window.
		show_debug_message(game_state_get_name(gameCurState) + ", " + game_state_get_name(gamePrevState));
	}
	
	/// @description Allows the setting/resetting of a desired flag to either 1 (true) or 0 (false), which will
	/// determine if certain objects (Ex. Collectibles) exist within the world or not, if special doorwars are
	/// locked or not, and so on.
	/// @param {Real}	flagID		The ID of the flag that is being manipulated.
	/// @param {Bool}	flagState	The state to set the flag bit to (1 = true, 0 = false).
	cmd_set_event_flag = function(_flagID, _flagState){
		// TODO -- Display the flag ID and state to let the user know they were successfully changed.
		show_debug_message("Flag with ID (" + string(_flagID) + ") was set to " + string(_flagState));
		event_set_flag(_flagID, _flagState);
	}
	
	// Add all console functions to this array, which is used to parse the string data that represents the
	// function from what was typed into the console in order to execute that function. THe size of the array
	// is stored after all the commands are added through here.
	array_push(validCommands,
		["exit_game",			cmd_exit_game],
		["game_state",			cmd_game_state],
		["set_event_flag",		cmd_set_event_flag, TYPE_REAL, TYPE_BOOL],
	);
	totalCommands = array_length(validCommands);
}

#endregion

#region Global functions related to obj_console
#endregion