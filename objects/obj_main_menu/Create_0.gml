/// @description Initializing Variables
// You can write your code in this editor

// Call the parent object's create event
event_inherited();
// Let this menu use the select key, but not the return key
canUseSelect = true;
// Assign sounds for the menu
closeSound = snd_menu_close1;
switchSound = snd_beam_select;
selectSound = snd_menu_select1;

// Modify the menu width and height
numRows = 5;
numColumns = 1;

// Fill the menu up with options and descriptions
menuOption[0, 0] = "File 01";
optionDesc[0, 0] = "Select a file to begin the game.";
menuOption[0, 1] = "File 02";
optionDesc[0, 1] = "Select a file to begin the game.";
menuOption[0, 2] = "File 03";
optionDesc[0, 2] = "Select a file to begin the game.";
menuOption[0, 3] = "Options";
optionDesc[0, 3] = "Adjust various in-game settings.";
menuOption[0, 4] = "Exit Game";
optionDesc[0, 4] = "Return to the desktop.";

// Variables that are unique to the Main Menu
exitingGame = false;
fileToLoad = "";

// Set the speed for the background stars
alarm[0] = 1;

// Setting up the surface for drawing the menu
menuSurf = surface_create(global.camWidth, global.camHeight);
xOffset = 120;