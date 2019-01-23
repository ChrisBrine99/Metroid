/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

yOffset = global.camY + 30;
xOffset = global.camX + 50;

if (room != rm_main_menu)
	rectCol = c_black;

// Create the menu
menuSize = 7;
scr_create_menu(menuSize);

// Editing the menu option's for the Options Menu
menuOption[0] = "Scanlines";
menuOption[1] = "Option2";
menuOption[2] = "Option3";
menuOption[3] = "Option4";
menuOption[4] = "Option5";
menuOption[5] = "Option6";
menuOption[6] = "Back";