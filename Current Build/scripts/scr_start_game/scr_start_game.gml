/// @Description Starts a new game if a save file doesn't exist. Loads up a file if it exists.
/// @param filename

// Temporary variable to hold the file's name
var filename;
filename = argument0;

// Variable that holds the save file's name in memory (Used for saving while in-game)
global.fileName = filename;
scr_create_fade(0, 0, c_black, 0, false);
if (obj_fade.setAlpha == 1){
	if (!file_exists(filename + ".dat")){ // Starting a new game since no file was found
		instance_create_depth(480, 108, 300, obj_samus);
		room_goto(rm_test01);
	}
	else{ // Loading up the save file that was found
		scr_load_game(filename);	
	}
}