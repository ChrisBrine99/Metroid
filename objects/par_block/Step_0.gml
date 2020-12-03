/// @description Handling Block Regeneration

if (isInactive){
	// Remove the block's collision box and make it invisible for the duration of inactivity
	if (mask_index != spr_empty){
		if (createDestroyEffect){ // An optional destroy effect for the destructible block
			var _effect = instance_create_depth(x, y, depth - 1, obj_dblock_destroyed);
			_effect.imgSpeedMod = 0.5;
		}
		mask_index = spr_empty;
		visible = false;
		return; // Exit early for first frame of inactivity
	}
	
	if (timeSpentInactive != -1){ // Count down frames before regenerating
		inactiveTimer += global.deltaTime;
		if (inactiveTimer >= timeSpentInactive){
			inactiveTimer = 0;
			isInactive = false;
			// Create the mandatory regeneration effect
			var _effect = instance_create_depth(x, y, depth - 1, obj_dblock_destroyed);
			with(_effect){
				image_index = sprite_get_number(sprite_index) - 1;
				parentBlock = other.id;
				imgSpeedMod = -0.5;
			}
		}
	} else{ // Delete the instance of the block itself
		instance_destroy(self);
	}
}