// Perform a check to see if the item that this collectible represents has been collected by the player or not.
// If they've collected it already, it will be deleted so they can't collect it again.
if (event_get_flag(flagBit)){
	instance_destroy(self);
	return; // Object destroyed; skip all other code.
}

// Check for a neaby destructible object and store its ID in the "destructibleID" variable, which is then used
// to handle more logic below. If no destructible objects exist, exit the event prematurely.
destructibleID = instance_nearest(x, y, par_destructible);
if (destructibleID == noone)
	return;

// Take that stored ID and perform a collision check against it. If the collision check returns true, the item
// is assumed to be obscured by the destructible, and will be set to "HIDDEN" as a result.
mask_index = -1;
if (place_meeting(x, y, destructibleID)) {stateFlags |= DEST_HIDDEN;}
else {destructibleID = noone;} // No item ball, remove the instance pointer.
mask_index = spr_empty_mask;