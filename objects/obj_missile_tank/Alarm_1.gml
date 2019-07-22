/// @description Edit the object's name and description
// You can write your code in this editor

if (obj_player.maxMissiles <= 0){ // The first-time message for obtaining a missile tank
	itemName = "Missile Launcher";
	itemDescription = "An upgrade that enables the arm cannon to fire standard issue\nmissiles that deal a lot of damage. They can also damage certain\nresiliant enemies and unlock red-coloured doors.";
} else{ // The normal message for obtaining a missile tank
	itemName = "Missile Tank";
	itemDescription = "Missile storage capacity has been permanently\nincreased by five.";	
}