/// @description Insert description here
// You can write your code in this editor

// Unlock the previous menu
with(prevMenu){
	selectedOption[X] = -1;
	selectedOption[Y] = -1;
	subMenu = noone;
}

// Call the parent object's destroy event
event_inherited();