/// @description Insert description here
// You can write your code in this editor

if (subIndex != 0){ // Checking if items like the morphball, bombs, space jump, and screw attack have been collected.
	if (global.item[index] == true){
		hasCollected = true;
		instance_destroy(self);
	}
} else{ // Checking if certain missile tanks, energy tanks, and the like have been collected
	if (global.item[subIndex] == true){
		hasCollected = true;
		instance_destroy(self);
	}
}