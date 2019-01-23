/// @description Destroy if Samus has already collected the Screw Attack
// You can write your code in this editor

// Modifying the variables
itemIndex = 6;
subIndex = -1;
itemName = "Screw Attack";
itemDescription = "Gives your mid-air somersault a devastating\neletric charge. Colliding with weaker enemies\nwhile somersaulting will obliterate them.";

color = c_orange;

if (global.screwAttack){
	giveReward = false;
	instance_destroy(self);
}