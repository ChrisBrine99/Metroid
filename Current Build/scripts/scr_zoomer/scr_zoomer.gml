/// @description Complicated AI with a very simple function: to move along the walls of rooms and along
/// platforms. GOD THIS IS GOING TO SUCK ASS TO PROGRAM

// Call the parent step event
event_inherited();

image_speed = imgSpd;
if (!canMove || frozen){
	speed = 0;
	image_speed = 0;
	return;
}

if (onGround){
	speed = spd;
	if (turnAngle <= 90){
		if (place_meeting(x + lengthdir_x(sign(spd), direction + 45 * sign(spd)), y + lengthdir_y(sign(spd), direction + 45 * sign(spd)), par_block)){
			direction += 45 * sign(spd);
			turnAngle += 45;
		}
		else if (!place_meeting(x + lengthdir_x(sign(spd), direction - 45 * sign(spd)), y + lengthdir_y(sign(spd), direction - 45 * sign(spd)), par_block)){
			direction -= 45 * sign(spd);
			turnAngle += 45;
		}
		else{
			turnAngle = 0;	
		}
	}
	else{
		turnAngle = 45;
		direction = 0;
		onGround = false;
	}
}
else{
	speed = 0;
	if (vspd < maxVspd)
		vspd += grav;
	// The zoomer's gravity
	if (place_meeting(x + lengthdir_x(1, direction - 90), y + lengthdir_y(1, direction - 90), par_block)){
		vspd = 0;
		onGround = true;
	}
	y += vspd;
}