/// @description Setting up all the required variables for the game.
// You can write your code in this editor

// The array that holds all of the main powerups in the game
for(var i = 0; i < global.totalItems; i++){
	global.item[i] = false;	// If true, the item at that index will delete itself
}

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
for (var d = 0; d < global.totalLockedDoors; d++){
	global.door[d] = false;	// If true, the door will be replaced by a generic blue door
}

// Variables for the current background song that is playing
curSong = -1;
song = -1;
fadingOut = false;
playMusic = false;
totalLength = 0;
fadeTime = 300;		// NOTE -- This time is in milliseconds AKA 1000 = 1 second
// Unseen here are:
//		global.curSong	--	The current song that is playing in the background.
//		global.offset	--	The amount of time in seconds to start from when looping a song.

// Variables for the Debug Mode
global.debugMode = false;
global.entities = ds_list_create();
showStreamlinedDebug = false;