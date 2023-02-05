// A switch/case statement that handles the connection and removal of a gamepad to be used in the game.
switch(async_load[? "event_type"]){
	case "gamepad discovered": // A gamepad has been connected to the PC
		var _gamepadID = async_load[? "pad_index"];
		// First, a check is made to make sure the gamepad is actually supported by SDL and Game Maker. If so,
		// the code will continue on with getting the gamepad's information for future input from the player.
		// Otherwise, don't do anything with the unsupported gamepad.
		if (gamepad_is_supported()){
			// 
			var _info = gamepad_get_guid(_gamepadID) + "," + gamepad_get_description(_gamepadID);
			with(GAME_SETTINGS){ // Scope into the settings struct to access the required variables.
				gamepad_set_axis_deadzone(_gamepadID, stickDeadzone);
				gamepad_set_button_threshold(_gamepadID, triggerThreshold);
			}
			
			// 
			with(GAMEPAD_MANAGER){
				deviceID = _gamepadID;
				if (deviceID >= 4 && deviceID <= 11) {gamepad_test_mapping(deviceID, gamepad_get_mapping_data(_info));}
			}
		}
		break;
	case "gamepad lost": // A gamepad was just disconnected from the PC
		with(GAMEPAD_MANAGER){
			// 
			if (!gamepad_is_connected(deviceID)){
				if (deviceID >= 4 && deviceID <= 11) {gamepad_remove_mapping(deviceID);}
				deviceID = -1;
				isActive = false;
				CONTROL_INFO.initialize_input_icons();
			}
		}
		break;
}