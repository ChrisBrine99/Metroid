/// @description Destroy if Samus has already collected the Springball
// You can write your code in this editor

// Modifying the variables
itemIndex = 3;
subIndex = -1;
itemName = "Spring Ball";
itemDescription = "Press [Jump] while in morphball mode\nto launch into the air.";

color = c_aqua;

if (global.springBall){
	giveReward = false;
	instance_destroy(self);
}