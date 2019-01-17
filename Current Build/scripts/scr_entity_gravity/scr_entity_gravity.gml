/// @description Calculates gravity. Place this at the top of an entity's step event.

// Pull the entity toward wherever the gravity direction is
if (!place_meeting(x, y + lengthdir_y(1, gravDir), par_block)){
	vspd += lengthdir_y(grav, gravDir);
	// Maxing out the vertical falling speed
	if (gravDir == 270 && vspd > maxVspd)
		vspd = maxVspd;
	else if (gravDir == 90 && vspd < -maxVspd)
		vspd = -maxVspd;
	onGround = false;
}
else{
	// Landing on the ground
	if (!onGround){
		hspd = 0;
		vspd = 0;
		jumping = false;
		jumpspin = false;
		onGround = true;
	}
}
// Checking the image_yscale to make sure it's the same as where the gravity is pulling the player toward
if (gravDir == 270)
	image_yscale = 1;	
else if (gravDir == 90)
	image_yscale = -1;	