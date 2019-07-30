/// @description Initializing Variables
// You can write your code in this editor

// The current selected menu element as well as the menu's total size
curIndex = 0;
menuSize = 0;

// Default Value for the menu element information
weaponInfo[0, 0] = -1;		// The weapon's icon
weaponInfo[0, 1] = "";		// The weapon's name
weaponInfo[0, 2] = "";		// The weapon's description
weaponInfo[0, 3] = 0;		// The weapon's index
weaponInfo[0, 4] = 0;		// The weapon's current ammo
weaponInfo[0, 5] = 0;		// The weapon's maximum ammo

// Variables for the menu transition
alpha = 0;
fadingOut = false;

// TODO -- Add Variable to hold the Blur Object's ID for quick reference

// The cooldown for quick swapping and opening the full menu
fullMenu = false;
alarm[0] = 10;