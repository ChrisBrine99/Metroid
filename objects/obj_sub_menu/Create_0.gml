/// @description Insert description here
// You can write your code in this editor

// Call the parent object's create event
event_inherited();
// Allow the menu to select and return
canUseSelect = true;
canUseReturn = true;

// Variables that are unique to all Sub Menus
inheritAllSounds = false;	// If true, the sub menu will poroduce the same sounds as the menu that created it
xPos = 0;					// The x coordinate of the sub menu on the GUI layer
yPos = 0;					// The y coordinate of the sub menu on the GUI layer
font = font_gui_small;		// The font that the menu will use. Can be carried over from the previous menu
otherIndex = -1;			// The index of the current selected option on the menu that created this one