/// @description Insert description here
// You can write your code in this editor

if (isDestroyed){ // Only call the parent's step event when this object is already destroyed
	event_inherited();	
} else{ // Checking for collisions with the player
	mask_index = sprite_index;
	if (place_meeting(x, y - 1, obj_player)){
		isDestroyed = true;
		destroyTimer = destroyTimerMax;
		// Create the block destroying effect
		instance_create_depth(x, y, depth, obj_dblock_destroy);
	}
}