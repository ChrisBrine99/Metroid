/// @description Destroy the item if it has been collected
// You can write your code in this editor

if (global.item[index + subIndex] == true){
	hasCollected = true;
	instance_destroy(self);
}