/// @description AI That will jump into the air and slowly glide back down to its original position.

// Call the parent step event
event_inherited();

if (!canMove || frozen){
	return;
}

scr_entity_gravity();

// Jumping
if (!jumping && onGround){
	hspd = 0;
	image_index = 0;
	cooldownTimer--;
	if (cooldownTimer <= 0){
		cooldownTimer = 75;
		jumping = true;
		vspd = jumpSpd;
		image_index = 1;
	}
}
else if (jumping){
	// Launching into the air
	if (vspd <= 0) {
		if (vspd == 0){
			// Find out if Samus is to the Chute Leech's right or left
			if (obj_samus.x < x){ // Moving left
				hspd = -maxHspd;
			}
			else if (obj_samus.x > x){ // Moving right
				hspd = maxHspd;
			}	
		}
	}
	else{
		if (hspd > 0) image_index = 3;
		else if (hspd < 0) image_index = 2;
		// Moving left and right
		hspd += accel * dir;
		if (hspd >= maxHspd) dir = -1;
		else if (hspd <= -maxHspd) dir = 1;
	}
}

// Calling the base collision script
scr_entity_collision(false, true, false);

image_speed = 0;