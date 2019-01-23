/// @description Destroy if Samus has already collected the Missile Tank
// You can write your code in this editor


// Modifying the variables
itemIndex = 13;
itemName = "Missile Tank";
if (global.missilesMax == 0){
	itemDescription = "Press [Control] and then [Fire] to shoot a\nmissile from your arm cannon.\nOpens Red Doors.";
}
else{
	themeToPlay = music_item2;
	itemDescription = "Missile capacity has been permanently\nincreased by 5.";
}

if (global.missile[subIndex]){
	giveReward = false;
	instance_destroy(self);
}

color = c_orange;

// itemDescription = "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM";