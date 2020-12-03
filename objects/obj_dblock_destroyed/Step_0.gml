/// @description Play Animation

image_index += global.deltaTime * imgSpeedMod;
if (imgSpeedMod > 0 && floor(image_index) >= sprite_get_number(sprite_index) - 1){
	instance_destroy(self);
} else if (imgSpeedMod < 0 && round(image_index) <= 0){
	if (!place_meeting(x, y, par_entity)){ // Check if the space if free to regenerate
		with(parentBlock){
			isInactive = false;
			mask_index = sprite_index;
			visible = true;
		}
	} else{ // Resets the block's inactive timer if an entity is obstructing it's position
		with(parentBlock){
			isInactive = true;
		}
	}
	// After the check, always destroy the effect
	instance_destroy(self);
}