/// @description Counting down until the item pickup despawns
// You can write your code in this editor

despawnTimer--;
if (despawnTimer <= 0){
	instance_destroy(self);
}