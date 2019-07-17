/// @description Edit the object's name and description
// You can write your code in this editor

if (obj_player.maxSMissiles <= 0){ // The first-time message for obtaining a missile tank
	itemName = "Super Missiles";
	itemDescription = "An upgrade to the standard missile launcher that enables\nthe firing of super missiles. These pack a massive punch;\ndecimating almost everything they hit. Opens purple doors.";
} else{ // The normal message for obtaining a missile tank
	itemName = "Super Missile Tank";
	itemDescription = "Super Missile storage capacity has been\npermanently increased by two.";	
}