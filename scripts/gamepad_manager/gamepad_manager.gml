#region Initializing any macros that are useful/related to the gamepad manager

// ------------------------------------------------------------------------------------------------------- //
//	A macro to simplify the look of the code whenever the gamepad manager struct needs to be referenced.   //	
// ------------------------------------------------------------------------------------------------------- //

#macro	GAMEPAD_MANAGER			global.gamepadManager

// ------------------------------------------------------------------------------------------------------- //
//	Macros that shorten the code needed to reference these important values from other objects. The first  //
//	will return the ID for the connected gamepad that was first found by the game, and the second will     //
//	return the state of the gamepad's "activity" flag to determine if keyboard input is polled or not.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GAMEPAD_ID				global.gamepadManager.deviceID
#macro	GAMEPAD_IS_ACTIVE		global.gamepadManager.isActive

#endregion

#region Initializing enumerators that are useful/related to the gamepad manager
#endregion

#region Initializing any globals that are useful/related to the gamepad manager
#endregion

#region The main object code for the gamepad manager

global.gamepadManager = {
	// The first value stores the ID that the gamepad is connected to, which is determined by the OS and
	// and what kind of controller was connected. Microsoft-supported controllers and Xbox gamepads will
	// always be located at IDs 0 through 3, whereas any other type of gamepad is given one of the slots
	// between 4 and 11. The second variable will tell the game whether or not the gamepad that is connected
	// is currently in use. False means the keyboard is active in that case.
	deviceID : -1,			// 0 to 4 = XInput, 4 to 11 = DirectInput
	isActive : false,
	
	/// @description A simple function that is called every single possible in-game frame in order to allow
	/// controller hotswapping to work within the game. In short, it does nothing if no device exists, and
	/// it will switch the "isActive" flag to true or false depending on the last detected input.
	step : function(){
		if (deviceID == -1) 
			return;
		
		var _isActive = isActive;
		if ((!isActive && gamepad_any_button(deviceID, true)) 
				|| (isActive && keyboard_check_pressed(vk_anykey))) 
			isActive = !isActive;
			
		if (_isActive != isActive)
			CONTROL_INFO.initialize_input_icons();
	},
}

#endregion

#region Global functions related to the gamepad manager

/// @description A simple function that works just like keyboard_check_pressed(vk_anykey) works within the
/// actual engine--just for a connected controller instead of the PC's keyboard. Optionally, the thumbsticks
/// can also be checked for input detection if required.
/// @param {Real}	device
/// @param {Bool}	includeSticks
function gamepad_any_button(_device, _includeSticks){
	// If there isn't a valid gamepad connected don't bother checking for any input.
	if (!gamepad_is_connected(_device)) 
		return -1;
	
	// Loop through all possible game pad buttongs and triggers to see if any input from them was triggered.
	// Return the constant value for the relative input the was detected so the function is deemed "true".
	for (var i = gp_face1; i <= gp_padr; i++){
		if (gamepad_button_check(_device, i)) 
			return i;
	}
	
	// If the flag to include stick input was toggled, another loop will be mad to check for input on either
	// the left thumbstick or the right thumbstick, respectively; returning the relative input constant for
	// whichever one was detected.
	if (_includeSticks){
		var _deadzone = gamepad_get_axis_deadzone(_device);
		for (var i = gp_axislh; i <= gp_axisrv; i++){
			if (abs(gamepad_axis_value(_device, i)) >= _deadzone) 
				return i;
		}
	}
	
	// No input was detected from the gamepad; a zero or "false" will be returned.
	return 0;
}

/// @description Gets the mapping data for the controller depending on what was connected to be used by the
/// player as an input source. This is only required for gamepads that are supported, but aren't classified
/// as "XInput" controllers, so they'll need their mapping adjusted to ensure they work properly with the
/// way GameMaker handles gamepad input detection.
/// @param gamepad
function gamepad_get_mapping_data(_gamepad){
	switch(_gamepad){
		case SONY_DUALSHOCK_FOUR:	return _gamepad + ",a:b1,b:b2,x:b0,y:b3,leftshoulder:b4,rightshoulder:b5,lefttrigger:a3,righttrigger:a4,guide:b13,start:b9,leftstick:b10,rightstick:b11,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a5,back:b12,";
		case SONY_DUALSENSE:		return _gamepad + ",a:b1,b:b2,x:b0,y:b3,leftshoulder:b4,rightshoulder:b5,lefttrigger:a3,righttrigger:a4,guide:b13,start:b9,leftstick:b10,rightstick:b11,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a5,back:b12,";
		default:					return ""; // An unsupported gamepad will return no mapping data.
	}
}

#endregion