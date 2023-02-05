// Perform a check to see if the item that this collectible represents has been collected by the player or not.
// If they've collected it already, it will be deleted so they can't collect it again.
if (event_get_flag(flagID)){
	instance_destroy(self);
	return; // Object destroyed; skip all other code.
}

// 
destructibleID = instance_nearest(x, y, par_destructible);
if (destructibleID == noone) {return;}

// 
mask_index = -1;
if (place_meeting(x, y, destructibleID)) {stateFlags |= (1 << HIDDEN);}
else {destructibleID = noone;} // No item ball, remove the instance pointer.
mask_index = spr_empty_mask;