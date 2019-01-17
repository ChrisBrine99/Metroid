/// @description Simple enemy AI that moves back and forth and switches directions once they come into contact
/// with a wall.

// Call the parent's step event
event_inherited();

image_speed = 1;
if (!canMove || frozen){
	image_speed = 0;
	exit;
}

// Call the basic left/right movement script
scr_enemy_horizontal_movement();

// Use the horizontal movement from scr_ripper
scr_entity_collision(false, true, false);

// Flip the direction of the Ripper
if (hspd == 0){
	if (right){
		right = false;
		left = true;
	}
	else if (left){
		right = true;
		left = false;
	}	
}