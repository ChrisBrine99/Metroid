/// @description Destroying the Object
// You can write your code in this editor

if (image_index == 0){
	// Set the block that spawned this effect back to solid again
	if (spawnerId != noone){
		if (!place_meeting(x, y, obj_player)){ // Checking to prevent the player from getting stuck
			with(spawnerId) {isDestroyed = false;}
		} else{ // Reset the regeneration timer if Samus is colliding with the block
			instance_create_depth(x, y, depth, obj_dblock_destroy);
			with(spawnerId){
				isDestroyed = true;
				destroyTimer = destroyTimerMax;
			}
		}
	}
	instance_destroy(self);
}