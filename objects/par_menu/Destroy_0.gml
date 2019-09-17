/// @description Create the Previous Menu/Next Menu if necessary
// You can write your code in this editor

if (!isClosing){ // Opening a previous menu (If one exists)
	if (prevMenu != noone){
		var menu, prevOption;
		menu = instance_create_depth(0, 0, depth, prevMenu);
		prevOption = [prevMenuOption[X], prevMenuOption[Y]];
		with(menu){
			curOption[X] = prevOption[X];
			curOption[Y] = prevOption[Y];
			// Make sure the opening sound effect doesn't play
			openSound = -1;
		}
	}
} else{ // Opening a new menu (If one exists)
	if (nextMenu != noone){
		var menu, objIndex, selOption;
		menu = instance_create_depth(0, 0, depth, nextMenu);
		objIndex = object_index;
		selOption = [curOption[X], curOption[Y]];
		with(menu){
			prevMenu = objIndex;
			prevMenuOption[X] = selOption[X];
			prevMenuOption[Y] = selOption[Y];
		}
	}
}