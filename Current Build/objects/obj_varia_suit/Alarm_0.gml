/// @description Destroy if Samus has already collected the Varia Suit
// You can write your code in this editor

// Modifying the variables
itemIndex = 7;
subIndex = -1;
itemName = "Varia Suit";
itemDescription = "An advanced version of the Power Suit that\nincreases damage resistance while also giving\ncomplete protection against extreme cold and heat.";

color = c_orange;

if (global.variaSuit){
	giveReward = false;
	instance_destroy(self);
}