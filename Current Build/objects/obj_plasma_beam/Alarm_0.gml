/// @description Destroy if Samus has already collected the Plasma Beam
// You can write your code in this editor

// Modifying the variables
itemIndex = 12;
subIndex = -1;
itemName = "Plasma Beam";
itemDescription = "A blast of pure energy that deals a ridiculous\namount of damage to anything it hits.\nOpens dark red doors.";

color = c_lime;

if (global.plasmaBeam){
	giveReward = false;
	instance_destroy(self);
}