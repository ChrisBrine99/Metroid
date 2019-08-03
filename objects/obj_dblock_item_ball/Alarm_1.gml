/// @description Check if This Needs to be Destroyed on Loading
// You can write your code in this editor

// Destroy this object if it isn't colliding with an item
var item = instance_place(x, y, par_interactable_block);
if (item == noone){
	instance_destroy(self);
	return;
}