/// @description Enabling/Disabling the Debug Menu
// You can write your code in this editor

#region Keyboard Input(s)

var keyPause, keyDebug, keyDebug2;
keyPause = keyboard_check_pressed(vk_escape);
keyDebug = keyboard_check_pressed(ord("D"));
keyDebug2 = keyboard_check(vk_lcontrol);

#endregion

#region Opening the Pause Menu/Debug Menu

if (keyPause){
	// TODO -- Create the Pause Menu here	
}

if (!global.debugMode){
	// Opening a streamlined debug menu
	if (keyDebug2 && keyDebug) {showStreamlinedDebug = !showStreamlinedDebug;}
	show_debug_overlay(showStreamlinedDebug);
}

// Opening the full debug menu
if (keyDebug && !keyDebug2){
	if (instance_exists(obj_debug_controller)){ // Disabling Debug Mode
		instance_destroy(obj_debug_controller);	
		global.debugMode = false;
	} else{	// Enabling Debug Mode
		instance_create_depth(0, 0, 10, obj_debug_controller);
		global.debugMode = true;
	}	
}

#endregion