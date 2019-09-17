// Code used to assign what background music is being played at the moment. The offset is what to start the song
// on when it loops around to the beginning.
global.curSong = music_rocky_maridia;
global.offset = 9.046;
global.loopLength = 81.399;

// Songs and their offsets/lengths:
//
// Surface of SR388			--		offset =	9.359,	loopLength =	60.510
// 8-bit Rocky Maridia		--		offset =	9.046,	loopLength =	81.399
// Brinstar					--		offset =	0.000,	loopLength =	53.881
// Item Room				--		offset =	0.809,	loopLength =	40.548
// Unknown0					--		offset =	0.000,	loopLength =	85.719
// Save Room Theme			--		offset =	0.000,	loopLength =	58.124
//
//	These stupid fucking values are beyond tedious to figure out pls send help

// Only execute this code before the game actually begins
if (!instance_exists(obj_controller)){
	// The Enumerator to keep track of the game's current state
	enum GAME_STATE{
		IN_GAME = 1000,
		PAUSED = 1001,
		CUTSCENE = 1002,
		IN_MENU = 1003,
	};
	global.gameState = GAME_STATE.IN_MENU;
	
	// The Enumerator for the unique item values for important items
	enum ITEM{
		MORPHBALL = 0,
		BOMBS = 1,
		SPRING_BALL = 2,
		HI_JUMP = 3,
		SPACE_JUMP = 4,
		SCREW_ATTACK = 5,
		VARIA_SUIT = 6,
		GRAVITY_SUIT = 7,
		ICE_BEAM = 8,
		WAVE_BEAM = 9,
		SPAZER_BEAM = 10,
		PLASMA_BEAM = 11,
		CHARGE_BEAM = 12,
		MISSILES = 25,
		SUPER_MISSILES = 75,
		POWER_BOMBS = 100,
		ENERGY_TANKS = 125,
	};
	
	// The Enumerator for the hierarchy of destructable blocks in the game
	enum DYNAMIC_BLOCK{
		FALL_THROUGH = 100,
		NORMAL = 150,
		MISSILE = 151,
		SUPER_MISSILE = 152,
		BOMB = 200,
		POWER_BOMB = 201,
		SCREW_ATTACK = 250,
	};
	
	// The Enumerator for the different types of doors that can be found in the game
	enum DOOR_TYPE{
		NORMAL = 300,
		ICE = 301,
		WAVE = 302,
		SPAZER = 303,
		PLASMA = 304,
		MISSILE = 305,
		SUPER_MISSILE = 306,
		POWER_BOMB = 307,
	};
	
	// The Enumerator for the possible shapes a light source can be
	enum LIGHT{
		CIRCLE = 400,
		RECT_FADE = 401,
		RECT_FULL = 402,
	};
	
	// The Enumerator for the types of colliders that can be found in the game
	enum COLLIDER{
		LIQUID = 500,
		GENERIC_HAZARD = 501,
		ENEMY = 502,
		ENEMY_PROJECTILE = 503,
		WARP = 504,
	};
	
	// The Enumerator for the in-game keybindings
	enum KEY{
		GAME_RIGHT = 0,
		GAME_LEFT = 1,
		GAME_UP = 2,
		GAME_DOWN = 3,
		USE_WEAPON = 4,
		JUMP = 5,
		SWAP_WEAPON = 6,
		PAUSE_GAME = 7,
		MENU_RIGHT = 0,
		MENU_LEFT = 1,
		MENU_UP = 2,
		MENU_DOWN = 3,
		SELECT = 4,
		RETURN = 5,
	};
	// Load in the player's preferred options
	scr_load_options("options");
	
	// Create the controller and camera objects
	instance_create_depth(0, 0, 10, obj_controller);
	instance_create_depth(10, 10, 0, obj_camera);
	
	// Create the lighting and bloom objects
	instance_create_depth(0, 0, 15, obj_lighting);	
	if (global.oVideo[4]){ // Only create if BLOOM IS ENABLED
		instance_create_depth(0, 0, 50, obj_bloom); 
	}
}

// Create the Main Menu
instance_create_depth(0, 0, 100, obj_main_menu);
// Create the Main Menu's Border
instance_create_depth(0, 0, 200, obj_menu_border);
// Create the Title Screen/Main Menu's Background Gradient
var back = instance_create_depth(0, 0, 400, obj_menu_background);
with(back) {col = make_color_rgb(0, 0, 90);}

// Edit the bloom and lighting system settings
show_debug_message(global.lightingID);
if (global.lightingID != noone){
	with(global.lightingID){
		show_debug_message(object_index);
		show_debug_message(obj_lighting);
		if (object_index == obj_lighting){
			curLightingCol = c_black;
		}
	}
}
if (global.bloomID != noone){
	with(global.bloomID){
		if (object_index == obj_bloom){
			blurSteps = 4;
			sigma = 0.25;
		}
	}
}

// Remove the player object if they exist (Ex. Going from the game back to the main menu)
if (global.playerID != noone){
	with(global.playerID){
		instance_destroy(self);	
	}
}