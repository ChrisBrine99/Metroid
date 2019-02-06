/// @description Initializing stuff
// You can write your code in this editor

// Call the parent's create event
event_inherited();

prevMenu = -1;

// Create the menu
menuSize = 2;
scr_create_menu(menuSize);

// Editing the menu option's for the Game Over Screen
menuOption[0] = "Continue";
menuOption[1] = "Main Menu";

// Destroying Samus and the controller object
instance_destroy(obj_samus);
instance_destroy(obj_controller);