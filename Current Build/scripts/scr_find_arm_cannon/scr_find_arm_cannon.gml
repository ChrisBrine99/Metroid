/// @description Finds where Samus's arm cannon is and sets the velocity according to the cannon's direciton

var multiplier;
multiplier = 1;
if (obj_samus.gravDir == 90) multiplier = -1;

// Finds the position of the arm cannon
if (!obj_samus.up && !obj_samus.down){
	if ((obj_samus.hspd > -1 && obj_samus.hspd < 1) || !obj_samus.onGround) { // If Samus is standing
		if (!obj_samus.facingRight){ // spawn to the left
			x = obj_samus.x - 16;
			left = true;
		}
		else if (obj_samus.facingRight){ // Spawn to the right
			x = obj_samus.x + 16;
			right = true;
		}
		if (!obj_samus.crouching){
			y = obj_samus.y - (3 * multiplier);
		}
		else{
			y = obj_samus.y + (7 * multiplier);
		}
	}
	else{ // If Samus is walking
		if (!obj_samus.facingRight){ // spawn to the left
			x = obj_samus.x - 22;
			left = true;
		}
		else if (obj_samus.facingRight){ // Spawn to the right
			x = obj_samus.x + 22;
			right = true;
		}
		y = obj_samus.y - (7 * multiplier);	
	}
}
else{
	if (obj_samus.up){
		if (!obj_samus.facingRight){ // spawn to the left
			if (obj_samus.onGround)
				x = obj_samus.x - 3;
			else
				x = obj_samus.x - 4;
		}
		else{	// Spawn to the right
			if (obj_samus.onGround)
				x = obj_samus.x + 3;
			else
				x = obj_samus.x + 4;
		}
		// Flip the bullet if Samus is on the ceiling
		y = obj_samus.y - (20 * multiplier);
		if (obj_samus.gravDir == 270){
			direction = 90;
			up = true;
		}
		else{
			direction = 270;
			down = true;	
		}
	}
	else if (obj_samus.down){
		if (!obj_samus.facingRight) // Spawn to the left
			x = obj_samus.x - 5;
		else // Spawn to the right
			x = obj_samus.x + 5;
		// Flip the bullet if Samus is on the ceiling
		y = obj_samus.y + (15 * multiplier);
		if (obj_samus.gravDir == 270){
			direction = 270;
			down = true;
		}
		else{
			direction = 90;
			up = true;	
		}
		if (obj_samus.vspd > 0) maxVspd += obj_samus.vspd;
	}
}
x += obj_samus.hspd;
if (obj_samus.vspd > 0) y += obj_samus.vspd;