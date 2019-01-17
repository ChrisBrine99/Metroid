/// @description Destroy if Samus has already collected the Space Jump
// You can write your code in this editor

// Modifying the variables
itemIndex = 5;
subIndex = -1;
itemName = "Space Jump";
itemDescription = "Press [Jump] while airborne to jump again.";

color = c_lime;

if (global.spaceJump){
	giveReward = false;
	instance_destroy(self);
}