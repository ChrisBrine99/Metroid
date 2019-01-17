/// @description Destroy if Samus has already collected the Bombs
// You can write your code in this editor

// Modifying the variables
itemIndex = 1;
subIndex = -1;
itemName = "Bombs";
itemDescription = "Press [Fire] while in morphball mode to deploy a\nbomb.";

color = c_aqua;

if (global.bombs){
	giveReward = false;
	instance_destroy(self);
}