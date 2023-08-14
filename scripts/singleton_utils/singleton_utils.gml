// Constants that shrink down the typing needed and overall clutter caused by having to reference any of the
// game's singleton objects. If any of these objects are destroyed, the game should close in order to prevent
// crashes or oddities from occuring.
#macro	CAMERA						global.sInstances[? obj_camera]
#macro	MUSIC_HANDLER				global.sInstances[? obj_music_handler]
#macro	EFFECT_HANDLER				global.sInstances[? obj_effect_handler]
#macro	CUTSCENE_MANAGER			global.sInstances[? obj_cutscene_manager]
#macro	TEXTBOX_HANDLER				global.sInstances[? obj_textbox_handler]
#macro	CONTROL_INFO				global.sInstances[? obj_control_info]
#macro	SCREEN_FADE					global.sInstances[? obj_screen_fade]
#macro	GAME_HUD					global.sInstances[? obj_game_hud]
#macro	CONTROLLER					global.sInstances[? obj_controller]
#macro	PLAYER						global.sInstances[? obj_player]
#macro	DEBUGGER					global.sInstances[? obj_debugger]

// A map that stores pointers/references to all singletons that exist within the game currently. An object being
// in this list will prevent copies of them from being instantiated (When used in tandem with the new functions
// "instance_create_object" and "instance_create_struct").
global.sInstances = ds_map_create();

/// @description A simple function that will check to see if the instance being created for an object is an 
/// already existing singleton object; returning true if one already exists and false if it doesn't exist OR
/// it's not a singleton object to begin with.
/// @param {Any}	object	The object index to check against the map of already existing singletons.
function singleton_instance_exists(_object){
	var _value = ds_map_find_value(global.sInstances, _object);
	if (is_undefined(_value)) {return false;}
	return true;
}