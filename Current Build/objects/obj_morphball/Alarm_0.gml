/// @description Destroy if Samus has already collected the Morphball
// You can write your code in this editor

// Modifying the variables
itemIndex = 0;
subIndex = -1;
itemName = "Morphball";
itemDescription = "Press [Down] while crouching to active\nmorphball mode. Gain access to narrow\npassageways while in this state.";

color = c_purple;

if (global.morphball){
	giveReward = false;
	instance_destroy(self);
}