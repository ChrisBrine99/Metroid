/// @description Initializing Variables
// You can write your code in this editor

// Call the parent object's create event
event_inherited();
// Let this menu use the select key as well as the return key
canUseSelect = true;
canUseReturn = true;
// Assign sounds for the menu
closeSound = snd_menu_close1;
switchSound = snd_beam_select;
selectSound = snd_menu_select1;

// Modify the menu width and height
numRows = 5;
numColumns = 1;

// Fill the menu up with options and descriptions
menuOption[0, 0] = "Resume Game";
optionDesc[0, 0] = "Exit the pause menu and return to the game.";
menuOption[0, 1] = "Inventory";
optionDesc[0, 1] = "View all your acquired items and equipment.";
menuOption[0, 2] = "Log Files";
optionDesc[0, 2] = "View information about the world and its creatures.";
menuOption[0, 3] = "Options";
optionDesc[0, 3] = "Adjust various in-game settings.";
menuOption[0, 4] = "Quit Game";
optionDesc[0, 4] = "Exit the game and return to the main menu.";

// Create the Main Menu's Border
var obj = instance_create_depth(0, 0, 20, obj_menu_border);
with(obj){
	rectAlpha = 0.5;
	rectCol = c_black;
}
xOffset = 200;

// Variables that are unique to the Pause Menu
exitingMenu = false;