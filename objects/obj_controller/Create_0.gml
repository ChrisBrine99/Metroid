/// @description Setting up all the required variables for the game.
// You can write your code in this editor

// Some helpful global variables for identical values that are referenced in multiple places
global.totalItems = 137;		// The total number of items (Ex. Morphball/Bombs/Missile Tanks) in the game
global.totalLockedDoors = 50;	// The total number of locked doors (Ex. Missile/Power Bomb Doors) in the game

// Calculate Delta Timing
global.targetFrameRate = 60;
global.deltaTime = get_delta_time();

// The array that holds all of the main powerups in the game
global.item = array_create(global.totalItems, false);

// The total amount of items is calculated as follows:
//		
//		Energy Tanks			--	 12	+
//		Missile Tanks			--	 50	+
//		Super Missile Tanks		--	 25	+
//		Power Bomb Tanks		--	 25	+
//		Beam Upgrades			--	  5	+		(Ice / Wave / Spazer / Plasma / Charge Beams)
//		Suit Upgrades			--	  2 +		(Varia / Gravity Suits)
//		Jump Upgrades			--	  3	+		(Hi-Jump / Space Jump / Screw Attack)
//		Morphball Upgrades		--	  3 +		(Morphball / Bombs / Spring Ball)
//									-----
//					Total Items	--	126
//

// The array that holds all of the locked doors in the game (Missile Doors, Power Bomb Doors, etc.)
global.door = array_create(global.totalLockedDoors, false);

// Global variables to holds the instance IDs for ALL PERSISTENT OBJECTS
global.cameraID = noone;		// ID for the camera
global.hudID = noone;			// ID for the in-game Heads-Up Display
global.playerID = noone;		// ID for the player object (Samus)
global.bloomID = noone;			// ID for the object that handles the bloom shader calculations
global.lightingID = noone;		// ID for the object that controls the in-game lighting system

// Variables for the current background song that is playing
curSong = -1;
song = -1;
fadingOut = false;
playMusic = true;
totalLength = 0;
fadeTime = 600;		// NOTE -- This time is in milliseconds AKA 1000 = 1 second
// Unseen Here Are:
//		global.curSong	--	The current song that is playing in the background.
//		global.offset	--	The amount of time in seconds to start from when looping a song.

// Variables for the Debug Mode
global.debugMode = false;
global.godMode = false;
global.entities = ds_list_create();
global.numDrawn = 0;
showStreamlinedDebug = false;