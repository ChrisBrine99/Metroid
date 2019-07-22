/// @description Edit the object's name and description
// You can write your code in this editor

if (obj_player.maxSMissiles <= 0){ // The first-time message for obtaining a missile tank
	itemName = "Power Bombs";
	itemDescription = "An upgrade to the standard bombs that allows for\nmassive destructive power. These will obliterate anything in sight upon\ndetonation. They also open yellow-coloured doors.";
} else{ // The normal message for obtaining a missile tank
	itemName = "Power Bomb Tank";
	itemDescription = "Power Bomb storage capacity has been\npermanently increased by two.";	
}