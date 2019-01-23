/// @description Destroy if Samus has already collected the Ice Beam
// You can write your code in this editor

// Modifying the variables
itemIndex = 9;
subIndex = -1;
itemName = "Ice Beam";
itemDescription = "This beam allows you to freeze weaker enemies\nto use them as platforms.\nOpens white doors.";

color = c_aqua;

if (global.iceBeam){
	giveReward = false;
	instance_destroy(self);
}