/// @description AI that will hop around left and right depending on if Samus is to its right of left. Also 
/// has a randomized short hop and regular hop.

// Call the parent step event
event_inherited();

image_speed = 0;
if (!canMove || frozen){
	return;
}

scr_entity_gravity();

if (!jumping){
	hspd = 0;
	if (!readyingJump){
		image_index = 0;
		cooldownTimer--;
		if (cooldownTimer <= 0){
			cooldownTimer = 120;
			readyingJump = true;
		}
	}
	else{
		image_index = 1;
		readyingTimer--;
		if (readyingTimer <= 0){
			readyingJump = false;
			readyingTimer = 10;
			// Find out if Samus is to the Sidehopper's right or left
			if (obj_samus.x < x){ // Moving left
				hspd = -maxHspd;
			}
			else if (obj_samus.x > x){ // Moving right
				hspd = maxHspd;	
			}
			jumping = true;
		}
	}
}

// Jumping
if (jumping && onGround){
	image_index = 2;
	// Setting a random jump height
	randomize();
	var rand = random(100);
	if (rand < 49) vspd = lengthdir_y(jumpSpd, gravDir);
	else vspd = lengthdir_y(jumpSpd, gravDir) / 1.5;
}

// Call the collision script
scr_entity_collision(true, true, false);