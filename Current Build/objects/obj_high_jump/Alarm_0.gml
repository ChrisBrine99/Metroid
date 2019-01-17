/// @description Destroy if Samus has already collected the High Jump Boots
// You can write your code in this editor

// Modifying the variables
itemIndex = 4;
subIndex = -1;
itemName = "High Jump Boots";
itemDescription = "Maximum jump height has been permanently increased.";

color = c_orange;

if (global.highJump){
	giveReward = false;
	instance_destroy(self);
}