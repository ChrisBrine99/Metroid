/// @description Moving the projectile
// You can write your code in this editor

#region Enabling/Disabling the Step Event/Destroying the Object When Its Off-Screen

// Check if the projectil is outside of the player's view
if (global.camX - 32 >= x || global.camY - 32 >= y || global.camX + global.camWidth + 32 <= x || global.camY + global.camHeight + 32 <= y){
	destroyFX = false;
	instance_destroy(self);
} 

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

#region Editing the size of the ambient light

if (ambLight != noone){
	if (left || right){ // Moving left or right
		ambLight.xRad = sprite_width * 2;
		ambLight.yRad = sprite_height * 2;
	} else if (up || down){ // Moving up or down
		ambLight.xRad = sprite_height * 2;
		ambLight.yRad = sprite_width * 2;
	}
}

#endregion