/// @description Check if Unlocked Already
// You can write your code in this editor

indexExists = variable_instance_exists(id, "index");
if (indexExists){
	if (global.door[index]){
		// Create Generic Door
		instance_create_depth(x, y, depth, obj_door_normal);
		// Destroy Locked Door Instance
		instance_destroy(self);
	}
}