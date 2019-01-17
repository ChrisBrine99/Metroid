/// @description Simple AI that hops toward the direction of the player.

// Call the parent step event
event_inherited();

if (!canMove || frozen){
	return;
}

// Call the entity's gravity script
scr_entity_gravity();

if (!jumping){
	image_index = 0;
	hspd = 0;
	cooldownTimer--;
	if (cooldownTimer <= 0){
		cooldownTimer = 15;
		jumping = true;
		vspd = jumpSpd;
		image_index = 1;
		// Find out if Samus is to the Hornoad's right or left
		if (obj_samus.x < x){ // Moving left
			image_xscale = -1;
			hspd = -maxHspd;
		}
		else if (obj_samus.x > x){ // Moving right
			image_xscale = 1;
			hspd = maxHspd;	
		}
	}
}
image_speed = 0;

// Call the basic collision script
scr_entity_collision(true, true, false);