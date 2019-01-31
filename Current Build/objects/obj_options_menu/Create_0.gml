/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

yOffset = global.camY + 30;
xOffset = global.camX + 50;

prevMenu = obj_main_menu;
if (room != rm_main_menu){
	prevMenu = obj_pause_menu;
	rectCol = c_green;
	backAlpha = 0.3;
}
drawBack = false;

// Create the menu
menuSize = 7;
scr_create_menu(menuSize);

// Editing the menu option's for the Options Menu
menuOption[0] = "Scanlines";
menuOption[1] = "V-Sync";
menuOption[2] = "Option3";
menuOption[3] = "Resolution";
menuOption[4] = "Controls";
menuOption[5] = "Reset To Default";
menuOption[6] = "Back";

for (var i = 0; i < 3; i++){
	if (global.option[i] == true) optionStr[i] = "On";
	else optionStr[i] = "Off";
}
optionStr[3] = string(global.option[i]) + "x [" + string(global.camWidth * global.option[i]) + " x " + string(global.camHeight * global.option[i]) + "]";