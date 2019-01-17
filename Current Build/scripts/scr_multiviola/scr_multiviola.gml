/// @description AI that bounces off of walls and flips horizontal and vertical direction whenever it does so.

// Call the parent step event
event_inherited();

if (!canMove || frozen){
	return;
}
imgDir += 30;
if (imgDir >= 360)
	imgDir = 0;
	
// Call the horizontal and vertical enemy movement scripts
scr_enemy_horizontal_movement();
scr_enemy_vertical_movement();

// Flip the image if the Multiviola is moving to the left
if (hspd < 0)
	image_xscale = -1;
else if (hspd > 0)
	image_xscale = 1;
	
// Call the collision script
scr_entity_collision(false, true, false);
// Flipping the horizontal and vertical speeds
if (hspd == 0){
	if (right){
		right = false;
		left = true;
	}
	else{
		right = true;
		left = false;
	}
}
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