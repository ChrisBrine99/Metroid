/// @description Initializing Variables
// You can write your code in this editor

// Call the parent's create event
event_inherited();
// Freeze the alpha change value until the menu needs to be created
alphaChangeVal = 0;
// Change the menu sound effects
switchSound = snd_beam_select;

// Default Value for the extra menu element information
menuOptionExt[0, 0] = 0;	// The weapon's index
menuOptionExt[0, 1] = 0;	// The weapon's current ammo
menuOptionExt[0, 2] = 0;	// The weapon's meximum ammo

displayTxt = "";		// The full unaltered sccreen
curDisplayedStr = "";	// The text that is currently being displayed on the screen
nextChar = 1;			// The next character to pulled from the "displayTxt" variable
curChar = 1;			// The current character that was added to the "curDisplayedStr" variable
txtSpeed = 2.5;			// How fast the text scrolling is

// The cooldown for quick swapping and opening the full menu
alarm[0] = 12 / global.deltaTime;