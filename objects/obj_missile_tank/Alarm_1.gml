/// @description Edit the object's name and description
// You can write your code in this editor

if (obj_player.numMissiles <= 0){ // The first-time message for obtaining a missile tank
	itemName = "Missile Launcher";
	itemDescription = "An upgrade that enables the arm cannon to fire standard issue missiles that deal a\nlot of damage. They can also damage certain resiliant enemies.\nOpens red doors.";
} else{ // The normal message for obtaining a missile tank
	itemName = "Missile Tank";
	itemDescription = "Missile storage capacity has been permanently\nincreased by five.";	
}