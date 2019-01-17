/// @description Creates a menu option array based on the size given in the argument space. These
/// options are used when making any kind of menu, as drawing the menu has nothing to do with how
/// those options are stored in memory.
/// @param menuSize

var menuSize;
menuSize = argument0;

// Creating the Menu Option array
for (var i = 0; i < menuSize; i++){
	menuOption[i] = "NoOption"; // Default option is "NoOption" -- can be overwritten.
}