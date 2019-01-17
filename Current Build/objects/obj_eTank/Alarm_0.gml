/// @description Destroy if Samus has already collected the Energy Tank
// You can write your code in this editor

// Modifying the variables
itemIndex = 16;
itemName = "Energy Tank";
itemDescription = "Maximum energy capacity has been permanently\nincreased by 100 units.";

color = c_aqua;

if (global.eTanksMax > 0){
	themeToPlay = music_item2;
}

// Destroy the energy tank is Samus has already collected it
if (global.eTank[subIndex]){
	giveReward = false;
	instance_destroy(self);
}
