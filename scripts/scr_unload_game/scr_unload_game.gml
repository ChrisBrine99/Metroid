/// @description Unloads and removes all the persistent objects in the game for when transitioning between
/// a menu room and the actual game areas.

// Remove the HUD object
if (global.hudID != noone){
	instance_destroy(global.hudID);
}
// Remove the player object
if (instance_exists(obj_player)){
	instance_destroy(obj_player);
	with(obj_camera) {curObject = self;}
}