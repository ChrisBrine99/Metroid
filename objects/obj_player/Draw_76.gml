/// @description Setting the player's current sprite based on their current state
// You can write your code in this editor

// Stop the player's sprite from updating if they cannot move
if (!canMove){
	return;	
}

// Setting Samus's Sprite ///////////////////////////////////////////////////////////////

// Standing Forward (Idle)
if (!hasStarted){
	image_xscale = 1;
	sprite_index = sprStand0;
	return;
}

// Morphball Sprites
if (inMorphball){
	sprite_index = sprMorphball1;
	image_speed = 1;
	return;	
}

// Standard Sprites
if (!missilesEquipped){ // Sprites while missiles aren't equipped
	if (onGround){ // Sprites while grounded
		if (!crouching){
			if (hspd > 0.9 || hspd < -0.9){ // Walking
				if (!isShooting && !up) {sprite_index = sprWalk0;}
				else if (!up) {sprite_index = sprWalk1;}
				else {sprite_index = sprWalk2;}
			} else{ // Standing Still
				if (!up) {sprite_index = sprStand1;}
				else {sprite_index = sprStand2;}
			}
		} else{ // Crouching
			sprite_index = sprCrouch1;	
		}
	} else{ // Sprites while airbourne
		if (jumpspin && !isShooting){ // Somersaulting
			if (global.item[ITEM.SCREW_ATTACK]) {sprite_index = sprJump0b;}
			else if (global.item[ITEM.SPACE_JUMP]) {sprite_index = sprJump0a;}
			else {sprite_index = sprJump0;}
		} else{ // Standard jumping
			if (!up && !down){ // Aiming Forward
				sprite_index = sprJump1;
			} else if (up && !down){ // Aiming Upward
				sprite_index = sprJump2;
			} else if (!up && down){ // Aiming Downward
				sprite_index = sprJump3;
			}
		}
	}
} else{ // Sprites while missiles are equipped
	if (onGround){
		if (!crouching){
			if (hspd >= 1 || hspd <= -1){ // Walking
				if (!isShooting && !up) {sprite_index = sprWalk0;}
				else if (!up) {sprite_index = sprWalk1m;}
				else {sprite_index = sprWalk2m;}
			} else{ // Standing Still
				if (!up) {sprite_index = sprStand1m;}
				else {sprite_index = sprStand2m;}	
			}
		} else{ // Crouching
			sprite_index = sprCrouch1m;	
		}
	} else{
		if (jumpspin && !isShooting){ // Somersaulting
			if (global.item[ITEM.SCREW_ATTACK]) {sprite_index = sprJump0b;}
			else if (global.item[ITEM.SPACE_JUMP]) {sprite_index = sprJump0a;}
			else {sprite_index = sprJump0;}
		} else{ // Standard jumping
			if (!up && !down){ // Aiming Forward
				sprite_index = sprJump1m;
			} else if (up && !down){ // Aiming Upward
				sprite_index = sprJump2m;
			} else if (!up && down){ // Aiming Downward
				sprite_index = sprJump3m;
			}	
		}
	}
}

// Setting the image speed while on the ground
if (onGround) {image_speed = abs(hspd / maxHspd);}
else {image_speed = 1;}

// Setting the direction that samus is facing
if (facingRight) {image_xscale = 1;}
else {image_xscale = -1;}

/////////////////////////////////////////////////////////////////////////////////////////