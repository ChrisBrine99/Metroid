/// @description Insert description here
// You can write your code in this editor

if (!isDestroyed && checkForCollision){ // Checking for collisions with the player
	mask_index = sprite_index;
	if (!obj_player.inMorphball && global.item[ITEM.SCREW_ATTACK]){
		if (place_meeting(x - (sign(obj_player.hspd) * 8), y - (sign(obj_player.vspd) * 8), obj_player) && obj_player.jumpspin){
			isDestroyed = true;
			destroyTimer = destroyTimerMax;
			// Create the block destroying effect
			instance_create_depth(x, y, depth, obj_dblock_destroy);
		}
	}
}

// Call the parent's step event
event_inherited();	