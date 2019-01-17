/// @description AI for the Rouge Wallfires mini-boss. It will move up and down based on if Samus has shot them.
/// It will also wrap to the bottom of the screen once it reaches the top or vice-versa.

// Call the parent's step event
event_inherited();

if (!canMove || frozen){
	return;
}

// Causes the wallfire to move faster the lower its hp is
if (vspdPenalty != 0){
	if (hitpoints == 15){
		vspdPenalty = 1;
		flipCooldownMax = 420;
		cooldownTimerMax = 60;
	}
	else if (hitpoints == 5){
		vspdPenalty = 0;
		flipCooldownMax = 240;
	}
}

// Movement
scr_enemy_vertical_movement();

// Firing a projectile across the screen
cooldownTimer--;
if (cooldownTimer <= 0){
	var obj;
	// Firing a normal bullet
	if (numFired < 3){
		obj = instance_create_depth(x + (10 * sign(image_xscale)), y, depth, obj_wallfire_proj0);
		obj.image_xscale = image_xscale;
		numFired++;
	}
	else{ // Firing out a bomb
		obj = instance_create_depth(x + (10 * sign(image_xscale)), y, depth, obj_wallfire_proj1);
		obj.image_xscale = image_xscale;
		numFired = 0;	
	}
	// Setting the direction of the projectile
	with(obj){
		if (image_xscale > 0)
			hspd = maxHspd;
		else if (image_xscale < 0)
			hspd = -maxHspd;
	}
	cooldownTimer = cooldownTimerMax;
	sprite_index = spr_wallfire_dormant;
}
// Make the wallfire charge up before it fires
if (cooldownTimer <= 45){
	sprite_index = spr_wallfire_firing;
	if (numFired >= 3)
		image_speed = 0;
}

// Stops the wallfire from flipping rapidly when shot in quick succession
if (flipCooldown > 0)
	flipCooldown--;
// Flipping the wallfre's movement
if (hit && flipCooldown <= 0){
	flipCooldown = flipCooldownMax;
	if (up){
		up = false;
		down = true;
	}
	else{
		up = true;
		down = false;
	}
}

// Call the collision script
scr_entity_collision(false, true, false);
// Switching directions
if (vspd == 0){
	if (up){
		up = false;
		down = true;
	}
	else{
		up = true;
		down = false;
	}
}

if (hitpoints > 0){
	// Update the positions of the shield
	s.x = x - 3;
	s.y = y + (sprite_height / 2) - 3;
}