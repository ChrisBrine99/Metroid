/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

yOffset = global.camY + 15;
xOffset = global.camX + 50;

prevMenu = obj_main_menu;
if (room != rm_main_menu){
	prevMenu = obj_pause_menu;
	rectCol = c_green;
	backAlpha = 0.3;
}
drawBack = false;

// Create the menu
menuSize = 8;
scr_create_menu(menuSize);

// Editing the menu option's for the Options Menu
menuOption[0] = "Scanlines";
menuOption[1] = "V-Sync";
menuOption[2] = "Resolution";
menuOption[3] = "Music Volume";
menuOption[4] = "Sound Volume";
menuOption[5] = "Controls";
menuOption[6] = "Reset To Default";
menuOption[7] = "Back";

for (var i = 0; i < 2; i++){
	if (global.option[i] == true) optionStr[i] = "On";
	else optionStr[i] = "Off";
}
optionStr[2] = string(global.option[2]) + "x [" + string(global.camWidth * global.option[2]) + " x " + string(global.camHeight * global.option[2]) + "]";
optionStr[3] = string(global.option[3]);
optionStr[4] = string(global.option[4]);