// -- PLACE THESE ENUMERATORS IN THE CREATION CODE OF THE FIRST ROOM IN THE GAME -- //

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

// The Enumerator to keep track of the game's current state
enum GAME_STATE{
	IN_GAME = 1000,
	PAUSED = 1001,
	CUTSCENE = 1002,
	IN_MENU = 1003,
};
global.gameState = GAME_STATE.IN_GAME;	// TODO -- Change to "GAME_STATE.IN_MENU" when moving this code later.

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
// The player will have curState and a curSubState variables to handle the actions they are currently performing.
// Some examples of a sub action would be shooting while jumping or aiming up while standing or walking.

instance_create_depth(64, 64, 305, obj_player);

// Some helpful global variables for identical values that are referenced in multiple places
global.totalItems = 137;		// The total number of items (Ex. Morphball or Bombs) in the game
global.totalLockedDoors = 50;	// The total number of locked doors in the game

// Create the controller and camera objects
instance_create_depth(0, 0, 0, obj_camera);
instance_create_depth(0, 0, 10, obj_controller);

//////////////////////////////////////////////////////////////////////////////////////