/// @description Handles gravity, Samus's movement and collision
// You can write your code in this editor

// Keyboard Variables
keyRight = keyboard_check(global.key[0]);			 // For moving to the right
keyLeft = keyboard_check(global.key[1]);			 // For moving to the left
keyUp = keyboard_check(global.key[2]);				 // For aiming up, standing up, and exiting morphball
keyDown = keyboard_check(global.key[3]);			 // For aiming down, crouching, and entering morphball
keyShoot = keyboard_check_pressed(global.key[4]);	 // For shooting beams and missiles or dropping bombs
keyJump = keyboard_check_pressed(global.key[5]);	 // For jumping
keyStopJump = keyboard_check_released(global.key[5]);// For controlling overall jump height

// If Samus is in her "starting" position or an item has currently been collected
if (global.isPaused || !canMove){
	exit;
}

// Call the gravity script
scr_entity_gravity();

if (onGround){
	beenHit = false;
	jumpspin = false;
	jumping = false;
	down = false;
	if (mask_index == spr_jumping_mask){
		if (gravDir == 270) y -= 8;
		else y += 8;
		mask_index = spr_standing_mask;
	}
	if (audio_is_playing(snd_samus_screwattack)) audio_stop_sound(snd_samus_screwattack);
	// The BOUNCE
	if (inMorphball){
		if (vspdRecoil < 0)
			vspd = vspdRecoil;
	}
}
else{
	// The BOUNCE
	if (inMorphball){
		if (vspd >= 4)
			vspdRecoil = -(vspd / 2);
		else
			vspdRecoil = 0;
	}
	else{
		if ((up || down) && jumpspin){
			jumpspin = false;
		}
	}
}

// Jumping
if (keyJump){
	if (!inMorphball){ // Jumping while not in morphball mode
		if ((onGround || (global.spaceJump && jumpspin && vspd > 2)) && !crouching){
			if (!place_meeting(x, y + lengthdir_y(1, gravDir - 180), par_block)){
				// Only set jumping to true if Samus can jump
				vspd = lengthdir_y(jumpSpd + (vspdPenalty / 2), gravDir);
				jumping = true;
				if (!isShooting){
					if (hspd != 0 && !up && !down) jumpspin = true;
				}
				// Play the jumping sound effect
				var jumpSnd;
				if (!global.screwAttack || (global.screwAttack && !jumpspin))
					jumpSnd = snd_samus_jump;
				else
					jumpSnd = snd_samus_screwattack;
				// Stop the jump sound from playing multiple times
				if (audio_is_playing(jumpSnd)) audio_stop_sound(jumpSnd);
				audio_play_sound(jumpSnd, 0, false);
			}
		}
		else if (!onGround && !jumpspin && !up && !down){
			isShooting = false;
			jumpspin = true;
			if (facingRight)
				hspd = maxHspd;
			else
				hspd = -maxHspd;
			// Playing the screw attack sound effect
			if (global.screwAttack){
				if (audio_is_playing(snd_samus_screwattack)) audio_stop_sound(snd_samus_screwattack);
				audio_play_sound(snd_samus_screwattack, 0, false);
			}
		}
		if (crouching)
			crouching = false;
	}
	else{
		if (global.springBall && onGround){
			if (audio_is_playing(snd_samus_jump)) audio_stop_sound(snd_samus_jump);
			if (!place_meeting(x, y - 1, par_block)) audio_play_sound(snd_samus_jump, 0, false);
			vspd = lengthdir_y((jumpSpd + (vspdPenalty / 2)) / 1.2, gravDir);
		}
	}
}
if (keyStopJump && ((vspd < 0 && gravDir == 270) || (vspd > 0 && gravDir == 90))){
	vspd /= 2;
}

// Horizontal Movement
if (keyRight){
	if (!left){
		facingRight = true;
		if (hspd < 0 && onGround) // Reset the hspd if it is negative (Only when on the ground)
			hspd = 0;
	}
	// Smoothlty accelerate
	if (!crouching && !beenHit){
		hspd += accel;
		if (hspd > maxHspd - hspdPenalty){
			hspd = maxHspd - hspdPenalty;
		}
	}
	right = true;
}
else{
	right = false;	
}
if (keyLeft){
	if (!right){
		facingRight = false;
		if (hspd > 0 && onGround) // Reset the hspd if it is positive (Only when on the ground)
			hspd = 0;
	}
	// Smoothly accelerate
	if (!crouching && !beenHit){
		hspd -= accel;
		if (hspd < -(maxHspd - hspdPenalty)){
			hspd = -(maxHspd - hspdPenalty);	
		}
	}
	left = true;
}
else{
	left = false;	
}
if ((keyRight && keyLeft) || (!keyRight && !keyLeft)){ // Stopping Horizontal Movement
	if (!jumpspin && !beenHit){
		if (hspd < -accel){
			hspd += accel;
		}
		else if (hspd > accel){
			hspd -= accel;	
		}
		else{
			hspd = 0;
		}
	}
	// Make sure Samus isn't going faster than her max speed
	if (hspd > maxHspd - hspdPenalty){
		hspd = maxHspd - hspdPenalty;	
	}
	else if (hspd < -(maxHspd - hspdPenalty)){
		hspd = -(maxHspd - hspdPenalty);	
	}
}

if (crouching){
	if (left || right){ // Countdown to standing up
		standTimer--;
		if (standTimer <= 0){
			crouching = false;
			standTimer = 20;
		}
	}
	else{ // Reset the standing timer if the player isn't holding the left or right keys down
		standTimer = 20;
	}
}

if (keyUp){ // Aiming Up/Exiting Morphball/Standing Up
	if (!crouching && !inMorphball){
		up = true;
		down = false;
	}
	if (!upKeyPressed){
		if (inMorphball && !place_meeting(x, y - 16, par_block)){ // Exiting Morphball
			audio_play_sound(snd_samus_transform, 0, false);
			inMorphball = false;
			if (onGround){
				hspd = 0;
				crouching = true;
				standTimer = 8;
			}
		}
		else if (crouching){ // Standing Up
			crouching = false;
		}
	}
	upKeyPressed = true;
}
else{
	up = false;
	upKeyPressed = false;
}
if (keyDown){ // Aiming Down/Crouching/Entering Morphball
	if (!onGround && !inMorphball){
		down = true;
		up = false;
	}
	else{
		if (!downKeyPressed){
			if (!crouching && !inMorphball){ // Crouching
				audio_play_sound(snd_samus_crouch, 0, false);
				up = false;
				crouching = true;	
				if (hspd != 0){
					hspd = 0;	
				}
			}
			else{ // Entering Morphball
				if (gravDir == 270){ // Samus will be unable to use her morphball while altering gravity
					if (global.morphball && !inMorphball){
						audio_play_sound(snd_samus_transform, 0, false);
						crouching = false;
						standTimer = 20;
						inMorphball = true;
						vspdRecoil = 0;
					}
				}
			}
		}
	}
	downKeyPressed = true;	
}
else{
	down = false;
	downKeyPressed = false;
}
// Stopping the screw attack sound effect from playing while aiming
if (up || down){
	if (audio_is_playing(snd_samus_screwattack))
		audio_stop_sound(snd_samus_screwattack);
}

if (keyShoot){ // Shooting Samus's arm cannon/Dropping bombs
	if (!inMorphball){
		if (global.curEquipmentIndex < 1 || global.curEquipmentIndex > 2){ // Spawn a beam if Samus doesn't have her missiles selected
			if (global.curBeamIndex == 3){
				var b1, b2, b3;
				b1 = instance_create_depth(x, y, depth, obj_beam);
				b1.waveMotion = true;
				b1.topBeam = false;
				b2 = instance_create_depth(x, y, depth, obj_beam);
				b2.waveMotion = true;
				b2.topBeam = true;
				b3 = instance_create_depth(x, y, depth, obj_beam);
				b3.waveMotion = false;
				b3.topBeam = false;
			}
			else{
				instance_create_depth(x,y, depth + 1, obj_beam);
			}
		}
		else{ // Spawn a missile if Samus has her missiles selected
			if (global.curEquipmentIndex == 1 || global.curEquipmentIndex == 2 && !instance_exists(obj_missile)){
				instance_create_depth(x,y, depth + 1, obj_missile);	
			}
		}
		if (audio_is_playing(snd_samus_screwattack)) audio_stop_sound(snd_samus_screwattack);
		isShooting = true;
		cooldownTimer = 20;
		jumpspin = false;
	}
	else{
		if (global.bombs){
			if (global.curEquipmentIndex != 3){
				if (instance_number(obj_bomb) < 3)
					instance_create_depth(x, y + 12, 99, obj_bomb);
			}
			else{
				if (global.pBombs > 0){
					if (!instance_exists(obj_pBomb) && !instance_exists(obj_pBomb_explode)){
						global.pBombs--;
						instance_create_depth(x, y + 12, 99, obj_pBomb);
					}
				}
			}
		}
	}
}

if (isShooting){
	cooldownTimer--;
	if (cooldownTimer < 0){ // Making Samus not aim her gun anymore
		isShooting = false;
		cooldownTimer = 20;
	}
}

// Handling collision masks
if (onGround){
	if (!crouching && !inMorphball){ // Collision box while standing
		mask_index = spr_standing_mask;	
	}
	else if (crouching && !inMorphball){ // Collision box while crouching
		mask_index = spr_crouching_mask;	
	}
	else{	// Collision box as a morphball
		mask_index = spr_morphball_mask;
	}
}
else{ // Collision box while jumping
	if (!inMorphball) mask_index = spr_jumping_mask;	
}

// Colliding with a bomb explosion
if (inMorphball){
	if (instance_exists(obj_bomb_explode)){
		var bomb_explode = instance_nearest(x, y, obj_bomb_explode);
		if ((y + 12) - bomb_explode.y < 8){
			if (place_meeting(x, y, bomb_explode)){
				if (!place_meeting(x, y, par_liquid) || global.gravitySuit){
					vspd = -3;
					if (x < bomb_explode.x - 2) {
						jumpspin = true;
						hspd = -1;
						vspd += 1;
					}
					else if (x > bomb_explode.x + 2){
						jumpspin = true;
						hspd = 1;
						vspd += 1;
					}
				}
			}
		}
	}
}

// Check for collision with the enemy
if (instance_exists(par_enemy)){
	var enemy = instance_nearest(x, y, par_enemy);
	// Don't bother checking collision if the enemy doesn't deal any damage
	if (enemy.damage > 0){
		if (place_meeting(x + sign(hspd), y + sign(vspd), enemy)){
			if ((!jumpspin && global.screwAttack) || !global.screwAttack){
				if (!enemy.frozen && hitTimer <= 0){
					audio_play_sound(snd_samus_hit, 0, false);
					beenHit = true;
					hitTimer = 60;
					// Make Samus recoil from the hit
					jumpspin = false;
					crouching = false;
					if (!inMorphball) mask_index = spr_jumping_mask;
					vspd = -2;
					if (facingRight) hspd = -1;
					else hspd = 1;
					scr_update_energy(-round(enemy.damage * global.damageRes));
				}
			}
			else if (jumpspin && global.screwAttack){
				if (!enemy.hit){
					enemy.hit = true;
					enemy.hitpoints -= 10;
				}
			}
		}
	}
}
// Counting down the cooldownTimer
if (hitTimer > 0){
	hitTimer--;	
	if (hitTimer == 0 && beenHit){
		beenHit = false;	
	}
}
// Check for collision with an item pickup
if (instance_exists(par_item_drop)){
	var pickup = instance_nearest(x, y, par_item_drop);
	if (place_meeting(x + sign(hspd), y + sign(vspd), pickup)){
		pickup.hasCollided = true;
		instance_destroy(pickup);
	}
}

// Reset all variables before altering them
if (!onGround){
	if (hspd == 0){
		hspdPenalty = 0.7;
	}
}
else{
	hspdPenalty = 0;
	vspdPenalty = 0;
}
imageSpdPen = 1;
// Check for collision with a liquid
if (instance_exists(par_liquid)){
	accel = 0.3;
	grav = 0.25;
	maxVspd = 7;
	var liquid = instance_nearest(x, y, par_liquid);
	if (place_meeting(x, y, liquid)){
		if (!global.gravitySuit){
			accel = 0.15;
			grav = 0.1;
			maxVspd = 3;
			hspdPenalty = 1.1;
			vspdPenalty = 2.5;
			imageSpdPen = 2.5;
		}
		if (liquid.damage > 0 && liquid.canHurtSamus){
			liquid.canHurtSamus = false;
			scr_update_energy(round(-liquid.damage * global.damageRes));
			if (!audio_is_playing(snd_samus_hit)){
				audio_play_sound(snd_samus_hit, 1, false);
			}
		}
	}
}

// Check for collision with the screw attack dblock
if (instance_exists(par_dblock)){
	if (global.screwAttack && jumpspin){
		var dblock = instance_nearest(x + hspd, y + vspd, par_dblock);
		if (distance_to_object(dblock) < 12){
			with(dblock){
				if (setObject == -1 || setObject == 4)
					beenHit = true;	
			}
		}
	}
}

// Call the collision script
scr_entity_collision(true, true, false);