/// @description Moving the projectile
// You can write your code in this editor

#region Enabling/Disabling the Step Event/Destroying the Object When Its Off-Screen

// Check if the projectile is outside of the player's view
if (x < global.camX - 32 || y < global.camY - 32 || x > global.camX + global.camWidth + 32 || y > global.camY + global.camHeight + 32){
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
	imgXScale = 1;
	hspd += accel;
	if (hspd > maxHspd){
		hspd = maxHspd;	
	}
} else if (left){ // Moving to the left
	imgXScale = -1;
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
imgAngle = direction;

#endregion

#region Collision with the World And Other Entities

// Checking for collisions with the game's various doors
if (instance_exists(par_door)){
	var door, type;
	door = instance_nearest(x + sign(hspd), y + sign(vspd), par_door);
	type = door.doorType;
	// Make sure the door can actually be opened by the current projectile
	if (place_meeting(x + sign(hspd), y + sign(vspd), door)){
		if (type == DOOR_TYPE.NORMAL || type == primaryDoor || type == secondaryDoor){
			// Start the animation that will end with the door being destroyed
			with(door) {unlocked = true;}
		} else{ // Change theexplosion effect to the default "didn't do anything" collision
			destroyFX = true;
			FXobj = obj_generic_collide;
		}
		// Destroy the projectile if it can collide with walls
		if (destroyOnWallCollide) {instance_destroy(self);}
	}
}

// Checking for collisions with walls
scr_entity_collision(hspd, vspd, onGround, gravDir, false, destroyOnWallCollide, destroyOnWallCollide);

#endregion