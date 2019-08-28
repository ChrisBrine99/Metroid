/// @description Initializing Variables
// You can write your code in this editor

// Call the parent's create event
event_inherited();
// Let the Alpha Control know that it will destroy this object when transparent
destroyOnZero = true;
alphaChangeVal = 0;
// Change the menu sound effects
switchSound = snd_beam_select;

// Default Value for the extra menu element information
menuOptionExt[0, 0] = 0;	// The weapon's index
menuOptionExt[0, 1] = 0;	// The weapon's current ammo
menuOptionExt[0, 2] = 0;	// The weapon's meximum ammo

// The cooldown for quick swapping and opening the full menu
alarm[0] = 12 / global.deltaTime;