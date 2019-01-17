/// @description Assigning the correct sprite and drawing it to the screen
// You can write your code in this editor

// Stop drawing Samus when she dead
if (global.energy == 0 && global.eTanks == 0){
	return;	
}

if (!global.started){
	sprite_index = sprStand0;
	draw_self();
	return;
}

if (global.isPaused){
	image_speed = 0;
	draw_self();
	return;
}

// Setting Samus's sprite based on what action she is currently doing
var usingMissiles = false;
if (global.curEquipmentIndex == 1 || global.curEquipmentIndex == 2){
	usingMissiles = true;
}

if (!inMorphball){
	if (onGround){
		if (!crouching){
			if (hspd < 1 && hspd > -1){ // Standing Sprites
				if (!up){
					if (!usingMissiles) sprite_index = sprStand1;
					else sprite_index = sprStand1m;
				}
				else{
					if (!usingMissiles) sprite_index = sprStand2;
					else sprite_index = sprStand2m;
				}
				image_speed = 0;
			}
			else{ // Walking Sprites
				if (!up){
					if (!isShooting){
						sprite_index = sprWalk0;
					}
					else{
						if (!usingMissiles) sprite_index = sprWalk1;
						else sprite_index = sprWalk1m;
					}
				}
				else{
					if (!usingMissiles) sprite_index = sprWalk2;
					else sprite_index = sprWalk2m;
				}
				image_speed = abs(hspd) / 1.5;
			}
		}
		else{ // Crouching Sprites
			if (!usingMissiles) sprite_index = sprCrouch1;
			else sprite_index = sprCrouch1m;
			image_speed = 0;
		}
	}
	else{
		if (!up && !down){	
			if (jumpspin && !isShooting){
				if (!global.spaceJump && !global.screwAttack) sprite_index = sprJump0;
				else if (global.spaceJump && !global.screwAttack) sprite_index = sprJump0a;
				else sprite_index = sprJump0b;
				image_speed = 1.25 / imageSpdPen;
				// Creating the nice jump fx
				if (!instance_exists(obj_samus_jumpfx)){
					instance_create_depth(x, y, depth + 1, obj_samus_jumpfx);
				}
			}
			else{
				if (!usingMissiles) sprite_index = sprJump1;
				else sprite_index = sprJump1m;
				image_speed = 0;
			}
		}
		else{
			jumpspin = false;
			if (up){
				if (!usingMissiles) sprite_index = sprJump2;
				else sprite_index = sprJump2m;
			}
			else if (down){
				sprite_index = sprJump3;	
			}
			image_speed = 0;
		}
	}
}
else{ // Morphball Sprites
	image_speed = 1.2 / imageSpdPen;
	sprite_index = sprMorphball1;
}

// Setting Samus's direction
if (facingRight){
	image_xscale = 1;
}
else{
	image_xscale = -1;
}

randomize();
var flash = random(100);
if (hitTimer <= 0 || (hitTimer > 0 && flash < 49)){
	// Drawing the sprite
	draw_self();
}