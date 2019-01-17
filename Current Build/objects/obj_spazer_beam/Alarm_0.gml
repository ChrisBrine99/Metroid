/// @description Destroy if Samus has already collected the Spazer Beam
// You can write your code in this editor

// Modifying the variables
itemIndex = 11;
subIndex = -1;
itemName = "Spazer Beam";
itemDescription = "An upgraded version of the regular Power Beam that\ndoes a great deal of damage. Also widens the up\nand downward reach of the beam. Opens green doors.";

color = c_fuchsia;

if (global.spazerBeam){
	giveReward = false;
	instance_destroy(self);
}