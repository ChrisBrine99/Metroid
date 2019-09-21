/// @description Initialize the Settings Menu
// You can write your code in this editor

// Call the parent object's Create Event
event_inherited();
// Modify some of the inherited characteristics
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
menuOption[0, 0] = "Video";
optionDesc[0, 0] = "Adjust various graphical settings.";
menuOption[0, 1] = "Audio";
optionDesc[0, 1] = "Change the volume of in-game sounds and music.";
menuOption[0, 2] = "Controls";
optionDesc[0, 2] = "Re-map the game's control scheme.";
menuOption[0, 3] = "Default";
optionDesc[0, 3] = "Return all settings to their default values.";
menuOption[0, 4] = "Back";
optionDesc[0, 4] = "Exit the menu.";

// Unique variables for the Settings menu
subMenu = noone;

// Setting up the surface for drawing the menu
menuSurf = surface_create(global.camWidth, global.camHeight);
xOffset = 200;