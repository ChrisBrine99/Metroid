/// @description Destroy if Samus has already collected the Wave Beam
// You can write your code in this editor

// Modifying the variables
itemIndex = 10;
subIndex = -1;
itemName = "Wave Beam";
itemDescription = "An upgraded version of the Power Beam that\ndoes more damage and shoots through walls.\nOpens pink doors.";

color = c_purple;

if (global.waveBeam){
	giveReward = false;
	instance_destroy(self);
}