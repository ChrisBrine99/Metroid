/// @description 
// You can write your code in this editor

// Create the camera
instance_create_depth(obj_samus.x, obj_samus.y, 0, obj_camera);
// Create the lighting system when necessary
if (global.activeLightSystem){
	if (!instance_exists(obj_lighting)){
		instance_create_depth(x, y, depth + 1, obj_lighting);	
	}
}

// Only check to change the song if the player isn't spawning in
if (global.started){
	alarm[0] = 1;
}