/// @description Very basic AI that spins in cirles in the air.

// Call the parent's Step Event
event_inherited();

image_speed = 1;
if (!canMove || frozen){
	image_speed = 0;
	speed = 0;
	return;
}

speed = spd;
direction += -3 * sign(speed);