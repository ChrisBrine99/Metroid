/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

yOffset = global.camY + 27;
xOffset = global.camX + 20;

prevMenu = obj_options_menu;
if (room != rm_main_menu){
	rectCol = c_green;
	backAlpha = 0.3;
}

// Create the menu
menuSize = 17;
scr_create_menu(menuSize);

// Editing the menu option's for the Controls Menu
menuOption[0] = "Right";
menuOption[1] = "Left";
menuOption[2] = "Up";
menuOption[3] = "Down";
menuOption[4] = "Fire";
menuOption[5] = "Jump";
menuOption[6] = "Equip";
menuOption[7] = "Beam";
menuOption[8] = "Pause";
menuOption[9] = "Save";
menuOption[10] = "Up";
menuOption[11] = "Down";
menuOption[12] = "Right";
menuOption[13] = "Left";
menuOption[14] = "Select";
menuOption[15] = "Return";
menuOption[16] = "Delete";

timer = 3;
secAlpha = 0;
prevKey = -1;
secondKeyPressed = true;