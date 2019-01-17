/// @description Basic left/right movement that is to be used by any enemy AI that needs to move left and right.

if (right){ // Moving to the right
	// Smooth acceleration
	hspd += accel;
	if (hspd > maxHspd - hspdPenalty || accel == 0){
		hspd = maxHspd - hspdPenalty;	
	}
	image_xscale = 1; // Face the sprite to the right
}
if (left){ // Moving to the left
	// Smooth acceleration
	hspd -= accel;
	if (hspd < -(maxHspd - hspdPenalty) || accel == 0){
		hspd = -(maxHspd - hspdPenalty);
	}
	image_xscale = -1; // Face the sprite to the left
}