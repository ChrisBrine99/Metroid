/// @description Destroy if Samus has already collected the Spazer Beam
// You can write your code in this editor

// Modifying the variables
itemIndex = 11;
subIndex = -1;
itemName = "Spazer Beam";
itemDescription = "An upgraded version of the regular Power Beam\nthat does a great deal of damage.\nOpens green doors.";

color = c_fuchsia;

if (global.spazerBeam){
	giveReward = false;
	instance_destroy(self);
}