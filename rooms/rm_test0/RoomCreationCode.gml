// -- PLACE THESE ENUMERATORS AND THE CODE BELOW IN THE CREATION CODE OF THE FIRST ROOM IN THE GAME -- //

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
if (!instance_exists(obj_camera) && !instance_exists(obj_controller)){
	// The Enumerator to keep track of the game's current state
	enum GAME_STATE{
		IN_GAME = 1000,
		PAUSED = 1001,
		CUTSCENE = 1002,
		IN_MENU = 1003,
	};
	global.gameState = GAME_STATE.IN_GAME;	// TODO -- Change to "GAME_STATE.IN_MENU" when moving this code later.
	
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
	
	// Creating the Player
	instance_create_depth(856, 316, 305, obj_player);

	// Some helpful global variables for identical values that are referenced in multiple places
	global.totalItems = 137;		// The total number of items (Ex. Morphball/Bombs/Missile Tanks) in the game
	global.totalLockedDoors = 50;	// The total number of locked doors (Ex. Missile/Power Bomb Doors) in the game

	// Create the controller and camera objects
	instance_create_depth(856, 316, 0, obj_camera);
	instance_create_depth(0, 0, 10, obj_controller);
	
	// Create the lighting and bloom objects
	instance_create_depth(0, 0, 15, obj_lighting);	
	instance_create_depth(0, 0, 45, obj_bloom); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////