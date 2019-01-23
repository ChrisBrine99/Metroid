/// @description Destroy if Samus has already collected the Power Bomb Tank
// You can write your code in this editor

// Modifying the variables
itemIndex = 15;
itemName = "Power Bomb Tank";
if (global.pBombsMax == 0){
	itemDescription = "Press [Control] three times and then [Fire] while\nin morphball to deploy a power bomb.\nOpens Yellow Doors.";
}
else{
	themeToPlay = music_item2;
	itemDescription = "Power Bomb capacity has been permanently\nincreased by 2.";
}

if (global.pBomb[subIndex]){
	giveReward = false;
	instance_destroy(self);
}

color = c_fuchsia;
