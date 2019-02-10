/// @description Simple AI that will walk along a horizontal platform or the ground and will switch directions
/// if reaches the edge of a platform, when it hits a wall, OR it has moved a certain distance. After a certain
/// amount of time has passed (Or Samus has fired at it), the Gravitt will dig into the ground, only exposing
/// its protected head until Samus gets far enough away.

// Call par_enemy's step event
event_inherited();

if (!canMove || frozen){
	image_speed = 0;
	return;
}

// Update the position of the shield object
if (hitpoints > 0){
	s.x = x - (sprite_width / 2);
	s.y = y - 7;
}

// Code for when the Gravitt is digging into or out of the ground
if (inGround){
	image_speed = 0;
	if (y < startY + 10){ // Dig into the ground
		y += 0.5;
	}
	else{ // Stay in the ground until Samus gets far enough away
		if (distance_to_object(obj_samus) > 100){
			inGround = false;
			risingUp = true;
		}
	}
	return;
}
else{
	image_speed = 0;
	if (risingUp){
		y -= 0.5;
		if (y == startY)
			risingUp = false;
	}
}
// Dig into the ground if Samus hits the Gravitt with her beam
if (cooldownTimer > 0){
	cooldownTimer--;
}
else if (hit){
	inGround = true;
	startY = y;
	cooldownTimer = 120;
}
image_speed = 1;

// Call the basic horizontal movement script
scr_enemy_horizontal_movement();

// Call the entity collision script
scr_entity_collision(true, true, false);
// Flipping directions
turnTimer--;
if (turnTimer <= 0){
	hspd = 0;
}
if (hspd == 0){
	turnTimer = 240;
	if (right){
		right = false;
		left = true;
	}
	else{
		right = true;
		left = false;
	}
}