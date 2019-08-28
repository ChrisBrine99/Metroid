/// @description Calculates gravity. Place this at the top of an entity's step event.
///	NOTE -- This script must be placed in the step event of an object in order to function.

var yCheck;
if (global.deltaTime > 1) {yCheck = lengthdir_y(global.deltaTime, gravDir);}
else {yCheck = lengthdir_y(1, gravDir);}

// If the entity's gravity is switched off, don't bother checking
if (grav == 0 || event_type != ev_step){
	return;	
}

// Pull the entity toward wherever the gravity direction is
if (!place_meeting(x, y + yCheck, par_block)){
	vspd = scr_update_value_delta(vspd, lengthdir_y(grav, gravDir));
	// Maxing out the vertical falling speed
	if (gravDir == 270 && vspd > maxVspd) {vspd = maxVspd;}
	else if (gravDir == 90 && vspd < -maxVspd) {vspd = -maxVspd;}
	onGround = false;
} else{
	// Landing on the ground
	if (!onGround){
		onGround = true;
	}
}
// Checking the image_yscale to make sure it's the same as where the gravity is pulling the player toward
if (gravDir == 270) {imgYScale = 1;}
else if (gravDir == 90) {imgYScale = -1;}