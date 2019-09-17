/// @description Inherit the Previous Menu's characteristics if necessary
// You can write your code in this editor

if (prevMenu != noone){
	// Inherit the opening and closing sound effects as well if necessary
	if (inheritAllSounds){
		openSound = prevMenu.openSound;
		closeSound = prevMenu.closeSound;
		// Play the menu opening sound
		event_inherited();
	} 
	// Carry over the previous menu's switching and selecting sound effects
	switchSound = prevMenu.switchSound;
	selectSound = prevMenu.selectSound;
}