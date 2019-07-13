/// @description Moving the projectile
// You can write your code in this editor

#region Enabling/Disabling the Step Event

// Stop the projectile from updating if they cannot move
if (!canMove){
	return;	
}

#endregion

#region  Horiontal/Vertical Movement

if (right){ // Moving to the right
	image_xscale = 1;
	hspd += accel;
	if (hspd > maxHspd){
		hspd = maxHspd;	
	}
} else if (left){ // Moving to the left
	image_xscale = -1;
	hspd -= accel;
	if (hspd < -maxHspd){
		hspd = -maxHspd;	
	}
}

if (up){ // Moving upward
	direction = 90;
	vspd -= accel;
	if (vspd < -maxVspd){
		vspd = -maxVspd;	
	}
} else if (down){ // Moving downward
	direction = 270;
	vspd += accel;
	if (vspd > maxVspd){
		vspd = maxVspd;	
	}
}
// Setting the image's direction
image_angle = direction;

#endregion

#region Collision with the World And Other Entities

// Checking for collisions with walls
scr_entity_collision(false, destroyOnWallCollide, destroyOnWallCollide);

#endregion