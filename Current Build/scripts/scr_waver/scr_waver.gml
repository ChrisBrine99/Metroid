/// @description Simple enemy AI that moves back and forth and switches directions once they come into contact
/// with a wall. Also moves up and down in a wave-like motion.

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

// Call the entity collision script
scr_entity_collision(true, true, false);
// Switch horizontal direction
if (hspd == 0){
	if (right){
		right = false;
		left = true;
	}
	else{
		right = true;
		left = false;
	}
}