/// @description Flying AI for the Rio and Geruta. It will fly back and forth until Samus gets near. Once Samus 
/// is within range, it will fly rapidly downward and upward in the direction of Samus.

// Call the parent Step Event
event_inherited();

if (!canMove || frozen){
	right = false;
	left = false;
	return;
}

// Begin readying the attack
if (readyingAttack){
	countdown--;
	image_index = 2;
	image_speed = 0;
	// Begin charging at Samus
	if (countdown <= 0){
		readyingAttack = false;
		attacking = true;
		countdown = 10;
	}
}

// Attacking A.I.
if (attacking){
	image_speed = 1;
	if (image_index == 0) image_index = 2;
	if (vspd == 0){ 
		vspd = maxVspd;
		// Set the direction that the Rio will fly in
		if (obj_samus.x < x){ // Begin moving left
			left = true;
			right = false;
		}
		else if (obj_samus.x >= x){ // Begin moving right
			left = false;
			right = true;
		}
	}
	// Setting the horizontal speed
	if (right) hspd = maxHspd;
	else if (left) hspd = -maxHspd;
	
}
else if (!attacking && !readyingAttack) { // Dormant A.I.
	image_speed = 1;
	if (image_index == 2) image_index = 0;
	// Stop attacking if Samus is far enough away
	if (obj_samus.x > x - 80 && obj_samus.x < x + 80){
		readyingAttack = true;
	}
	// Move back up to the ceiling 
	if (!place_meeting(x, y - 1, par_block)){
		vspd = -maxVspd / 4;
		hspd = 0;
	}
}

// Horizontal Collision
repeat(abs(hspd)){
	if (!place_meeting(x + sign(hspd), y, par_block)){
		x += sign(hspd);
	}
	else{
		if (hspd > 0) hspd = -maxHspd;
		else hspd = maxHspd;
	}	
}
// Vertical Collision
repeat(abs(vspd)){
	if (!place_meeting(x, y + sign(vspd), par_block)){
		y += sign(vspd);
	}
	else{
		// Flip the direction that the entity is heading in
		if (attacking){
			if (vspd > 0) vspd = -maxVspd;
			else vspd = maxVspd;
			// Stop attacking if Samus is far enough away
			if (place_meeting(x, y - 1, par_block)){
				if (obj_samus.x < x - 48 || obj_samus.x > x + 48){
					left = false;
					right = false;
					attacking = false;
				}
			}
		}
		else{
			vspd = 0;	
		}
	}
}