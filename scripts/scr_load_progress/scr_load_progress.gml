/// @description Attempts to load in one of the games save files. If no file was found or an error interrupts
/// the loading process, the game will default to starting the game from the beginning instead.
/// @param filename

var filename, map, length;
filename = argument0 + ".dat";
map = ds_map_create();
length = 0;

// Stop the background music so Samus's fanfare can play when the room loads is finished loading in
global.curSong = -1;
with(obj_controller) {playMusic = false;}

if (file_exists(filename)){ // Load the file if it exists
	map = ds_map_secure_load(filename);
	
	// Loads in the player's position and the current room they saved in
	var xx, yy, curRoom;
	xx = ds_map_find_value(map, "Player X");
	yy = ds_map_find_value(map, "Player Y");
	curRoom = ds_map_find_value(map, "Current Room");
	// Check if the loaded x and y values are valid; create the player based on those values if they are
	if (!is_undefined(xx) && !is_undefined(yy)) {instance_create_depth(xx, yy, 305, obj_player);}
	// Check if those loaded room data is actually valid; load if it is
	if (!is_undefined(curRoom)) {room_goto(curRoom);}
	
	// Load in all the player's currently collected items
	length = array_length_1d(global.item);
	for (var i = 0; i < length; i++){
		var key = ds_map_find_value(map, "item" + string(i));
		// Make sure the value actually exists, if not, set the value to its default
		if (!is_undefined(key)){
			global.item[i] = key;
		} else{
			global.item[i] = false;	
		}
	}
	// Set the player's sprites according to what suit(s) they have found already
	with(obj_player) {alarm[0] = 1;}
	
	// Load in all the locked doors that have been unlocked by the player
	length = array_length_1d(global.door);
	for (var d = 0; d < length; d++){
		var key = ds_map_find_value(map, "door" + string(d));
		// Make sure the value actually exists, if not, set the value to its default
		if (!is_undefined(key)){
			global.door[d] = key;
		} else{
			global.door[d] = false;	
		}
	}
	
	// TODO -- add loading calls to get the player's current in-game time
	
} else{ // Start the game from the beginning if no file exists
	room_goto(rm_test0);								// TODO -- change this to the actual starting room
	instance_create_depth(856, 316, 305, obj_player);	// TODO -- change coordinates to new positions after the room change
}

// Destroy the ds_map to prevent memory leaks
ds_map_destroy(map);