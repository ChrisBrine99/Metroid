/// @description Simple enemy AI that moves back and forth and switches directions once they hit a wall OR
/// after a certain amount of time has passed. Also moves up and down in a wave-like motion.

// Call the parent step event
event_inherited();

image_speed = 1;
if (!canMove || frozen){
	image_speed = 0;
	return;
}

// Call the basic left/right movement script
scr_enemy_horizontal_movement();
// Call the basic up/down movement script
scr_enemy_vertical_movement();

// The stuff for changing directions
if (vspd == maxVspd && down){
	up = true;
	down = false;
}
else if (vspd == -maxVspd && up){
	up = false;
	down = true;
}

// The turning stuff
if (turnTimer != -1){
	if (hspd == 0) turnTimer = 200;
	// Switching directions when not colliding with a wall
	turnTimer--;
	if (turnTimer <= 0){
		turnTimer = 90;
		if (left){
			left = false;
			right = true;
		}
		else{
			left = true;
			right = false;
		}
	}
}

// Call the collision script
scr_entity_collision(false, true, false);

if (hitpoints > 0){
	// Update the positions of each shield object
	s0.x = x - (sPos + shieldSizeX);
	s0.y = y - 2;
	s1.x = x + sPos;
	s1.y = y - 2;
}