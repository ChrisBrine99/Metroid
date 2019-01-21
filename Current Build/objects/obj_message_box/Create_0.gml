/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

xOffset = global.camX + (global.camWidth / 2);
yOffset = global.camY + 75;
textPos = -35;
textGap = 12;

// Create the menu
menuSize = 2;
scr_create_menu(menuSize);

answer = false;

// Editing the menu option's for the Sub Menu
menuOption[0] = "Yes";
menuOption[1] = "No";

drawBack = false;
drawHelp = false;