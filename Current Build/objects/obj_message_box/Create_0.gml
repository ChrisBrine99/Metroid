/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

xOffset = global.camX + (global.camWidth / 2);
yOffset = global.camY + (global.camHeight / 2);
textPos = -35;
textGap = 12;

backAlpha = 0.3;

prevMenu = -1;

// Create the menu
menuSize = 2;
scr_create_menu(menuSize);
// Editing the menu option's for the Sub Menu
menuOption[0] = "Yes";
menuOption[1] = "No";

answer = false;

drawBack = false;
drawHelp = false;