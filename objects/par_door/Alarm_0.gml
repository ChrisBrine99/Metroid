/// @description Check if Unlocked Already
// You can write your code in this editor

if (index >= 0){
	if (global.door[index]){
		// Create Generic Door
		instance_create_depth(x, y, depth, obj_door_normal);
		// Destroy Locked Door Instance
		instance_destroy(self);
	}
}