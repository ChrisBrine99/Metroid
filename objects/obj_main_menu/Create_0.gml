/// @description Initializing Variables
// You can write your code in this editor

// Call the parent object's create event
event_inherited();
// Let this menu use the select key, but not the return key
canUseSelect = true;

// Modify the menu width and height
numRows = 5;
numColumns = 1;

// Fill the menu up with options and descriptions
menuOption[0, 0] = "File 01";
optionDesc[0, 0] = "Select a file to begin the game.";
menuOption[1, 0] = "File 02";
optionDesc[1, 0] = "Select a file to begin the game.";
menuOption[2, 0] = "File 03";
optionDesc[3, 0] = "Select a file to begin the game.";
menuOption[3, 0] = "Options";
optionDesc[3, 0] = "Adjust various in-game settings.";
menuOption[4, 0] = "Exit Game";
optionDesc[4, 0] = "Return to the desktop.";

// Variables that are unique to the Main Menu
exitingGame = false;
fileToLoad = "";