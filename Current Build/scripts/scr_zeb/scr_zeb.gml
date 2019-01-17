/// @description Spawns in, moves upward until Samus's y is equal to its y. Then, it will begin moving
/// toward Samus; disappearing when going off screen.

// Call the parent step event
event_inherited();


image_speed = 1;
if (!canMove || frozen){
	image_speed = 0;
	return;
}

if (moveToPlayer){
	// Call the basic left/right movement script
	scr_enemy_horizontal_movement();
	x += hspd;
}
else{
	// Vertical Movement
	vspd = -maxVspd;
	var destY;
	if (!obj_samus.inMorphball) destY = 10;
	else destY = 5;
	// Check if the Zeb's y is equal to Samus's y
	if (y <= obj_samus.y - destY && startY - y > 24){
		if ((!place_meeting(x + 16, y, par_block) && right) || (!place_meeting(x - 16, y, par_block) && left)){
			vspd = 0;
			moveToPlayer = true;
		}
	}
	y += vspd;
}