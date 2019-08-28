/// @description Create the Previous Menu/Next Menu if necessary
// You can write your code in this editor

if (!isClosing){ // Opening a previous menu (If one exists)
	if (prevMenu != noone){
		instance_create_depth(0, 0, depth, prevMenu);
	}
} else{ // Opening a new menu (If one exists)
	if (nextMenu != noone){
		var menu = instance_create_depth(0, 0, depth, nextMenu);
		menu.prevMenu = instance_id;
	}
}