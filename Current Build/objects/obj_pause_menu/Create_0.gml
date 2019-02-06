/// @description Initializing menu stuff
// You can write your code in this editor

// Call the parent's create event
event_inherited();

xOffset = global.camX + 50;
yOffset = global.camY + 70;

backAlpha = 0.3;
rectCol = c_green;
drawBack = false;

// Create the menu
menuSize = 3;
scr_create_menu(menuSize);

// Editing the menu option's for the Game Over Screen
menuOption[0] = "Resume Game";
menuOption[1] = "Options";
menuOption[2] = "Main Menu";

// Pause the game
global.isPaused = true;

// Stop Samus from moving
obj_samus.canMove = false;

keyPressed = false;
prevMenu = -1;
nextMenu = obj_options_menu;