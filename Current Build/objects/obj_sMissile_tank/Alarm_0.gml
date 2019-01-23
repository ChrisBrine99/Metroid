/// @description Destroy if Samus has already collected the Super Missile Tank
// You can write your code in this editor

// Modifying the variables
itemIndex = 14;
itemName = "Super Missile Tank";
if (global.sMissilesMax == 0){
	itemDescription = "Press [Control] twice and then [Fire] to shoot\na super missile.\nOpens Purple Doors.";
}
else{
	themeToPlay = music_item2;
	itemDescription = "Super Missile capacity has been permanently\nincreased by 2.";
}

if (global.sMissile[subIndex]){
	giveReward = false;
	instance_destroy(self);
}

color = c_fuchsia;