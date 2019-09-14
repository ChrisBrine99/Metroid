/// @description Initialize the Border
// You can write your code in this editor

// Make sure no more than two menu borders ever exist at any given time
if (instance_number(obj_menu_border) > 1){
	instance_destroy(self);	
}

// Enable the Alpha Control system on the menu border
scr_alpha_control_create();