/// @description Initizalizes Samus's energy, missile capacity, power bomb capacity, and powerup variables
// You can write your code in this editor

// All of the powerup variables ///////////////////////////////////////////////////////////////////////////////////
global.morphball = false;			// If true, Samus will be able to enter morphball mode
global.bombs = false;				// If true, Samus will be able to use bombs when in morphball
global.spiderBall = false;			// If true, Samus will be able to cling to walls while in morphball
global.springBall = false;			// If true, Samus will gain the ability to jump in morphball mode
global.highJump = false;			// If true, Samus's jump height will be increased
global.spaceJump = false;			// If true, Samus will be able to jump while airborne
global.screwAttack = false;			// If true, Samus will be able to damage enemies while somersaulting
global.variaSuit = false;			// If true, Samus will resist extreme temperatures and will recieve only 50% damage
global.gravitySuit = false;			// If true, Samus will be able to move in water like they do out of water
global.iceBeam = false;				// If true, Samus will have access to the Ice Beam (Opens Cyan Doors)
global.waveBeam = false;			// If true, Samus will have access to the Wave Beam (Opens Pink Doors)
global.spazerBeam = false;			// If true, Samus will have access to the Spazer Beam (Opens Light Green Doors)
global.plasmaBeam = false;			// If true, Samus will have access to the Plasma Beam (Opens Maroon Doors)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Variables to hold Samus's health and Missile/Power Bomb counts
global.energy = 99;				// Holds Samus's current energy level
global.maxEnergy = 99;			// Holds the max amount of energy Samus can have
global.eTanksMax = 0;			// Holds the maximum amount of Energy Tanks Samus currently has
global.eTanks = 0;				// Holds Samus's current energy tank stock
global.damageRes = 1;			// Holds the amount of damage that Samus resists from incoming attacks

global.auxEnergy = 0;			// Hold's Samus's current auxillary energy level (Subitems will use this energy)
global.auxEnergyMax = 0;		// The current maximum auxillary energy Samus can hold

global.missiles = 0;			// Holds the amount of missiles Samus currently has (Opens Bright Red Doors)
global.missilesMax = 0;			// Holds the maximum amount of missile Samus can hold at one time
global.sMissiles = 0;			// Holds the amount of super missiles Samus current has (Opens Purple Doors)
global.sMissilesMax = 0;		// Holds the maximum amount of super missiles Samus can hold at one time
global.pBombs = 0;				// Holds the amount of power bombs Samus current has (Opens Light Yellow Doors)
global.pBombsMax = 0;			// Holds the maximum amount of power bombs Samus can hold at one time

// 0 = Nothing selected, 1 = Missiles selected, 2 = Super Missiles selected, 3 = Power Bombs selected
global.maxEquipmentIndex = 0;
global.curEquipmentIndex = 0;

// 0 = Powerbeam, 1 = Icebeam, 2 = Wavebeam, 3 = Spazerbeam, 4 = Plasmabeam
global.maxBeamIndex = 0;
global.curBeamIndex = 0;

// Variable to tell the game whether or not it should pause all entity movement or not
global.isPaused = false;
// Variable to hold if the player has started moving or not
global.started = false;

// Variable to hold whether or not a room should use the lighting system or not
global.activeLightSystem = true;

// Variable to check whether or not the item collection screen is visible of not
global.itemCollected = false;
// Item collection screen variables
global.itemName = "";
global.itemDescription = "";
global.itemTheme = 0;

// Variables to hold how much time the player has been in-game
global.hours = 0;
global.minutes = 0;
global.seconds = 0;
secondTimer = 60;

// A variable for counting things like entities killed or vice-versa
global.num = 0;

// Stuff for the beam icons
showBeamsTimer = 60;
yPos = 20;
xPos = 2;
textAlpha = 1;

// Stuff for when Samus dies
rectAlpha = 0;
timeToFade = 90;

// Stuff for displaying little help messages/info messages
displayTxt = "";
displayTimer = 0;
displayTimerMax = 120;

// If true, God Mode will be activated
godMode = false;

// Variables to track which missiles, sMissiles, pBombs, and eTanks still exist in the world
// False = Not Collected, True = Collected
for (var m = 0; m < 50; m++) {global.missile[m] = false;}
for (var sm = 0; sm < 25; sm++) {global.sMissile[sm] = false;}
for (var pb = 0; pb < 25; pb++) {global.pBomb[pb] = false;}
for (var e = 0; e < 12; e++) {global.eTank[e] = false;}

// Variables to track Missile doors, Super Missile doors, and Power Bomb doors
for (var sp = 0; sp < 25; sp++) {global.spDoor[sp] = false;}
// Variable to track if certain events have been triggered or not
for (var ev = 0; ev < 25; ev++) {global.event[ev] = false;}

// Variables for the item acquired screen
global.itemName = "";
global.itemDescription = "";
alpha = 0;
fadeAway = false;

hasStarted = false;
curSong = -1;

// Play the intro fanfare
hasPlayed = false;

// Variable to activate/deactivate debug mode
global.debug = false;