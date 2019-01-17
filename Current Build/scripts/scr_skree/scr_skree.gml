/// @description AI that will wait until the player is underneath before plummeting to the ground in an attempt
/// to harm them. Spins slowly while dormant and will spin rapidly when falling.

// Call the parent step event
event_inherited();

if (!canMove || frozen){
	image_speed = 0;
	return;
}

if (attacking){
	image_speed = 5;
	// Time until the skree blows up after hitting the ground
	if (place_meeting(x, y + 1, par_block)){
		vspd = 0;
		hspd = 0;
		deathTimer--;
		if (deathTimer <= 0){
			instance_destroy(self);	
		}
	}else{
		vspd += jumpSpd;
		if (vspd > maxVspd){
			vspd = maxVspd;
		}
	}
}
else{
	image_speed = 1;
	// Begin attacking once Samus gets near
	if (obj_samus.x > x - 32 && obj_samus.x < x + 32){
		attacking = true;
		if (obj_samus.x < x) hspd = -maxHspd;
		else hspd = maxHspd;
	}
}

// Calling the base collision script
scr_entity_collision(false, true, false);