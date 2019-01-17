/// @description Handles collision between a dynamic entity and a wall.
/// @param useSlopes
/// @param stopMovement
/// @param destroyOnCollision

var useSlopes, stopMovement, destroyOnCollision;
useSlopes = argument0;
stopMovement = argument1;
destroyOnCollision = argument2;

// Horizontal Collision
repeat(abs(hspd)){
	if (!place_meeting(x + sign(hspd), y + lengthdir_y(1, gravDir), par_block) && onGround && useSlopes){
		x += sign(hspd);
		y += lengthdir_y(1, gravDir);
	}
	else if (!place_meeting(x + sign(hspd), y, par_block) || !stopMovement){
		x += sign(hspd);
	}
	else if (!place_meeting(x + sign(hspd), y + lengthdir_y(1, gravDir - 180), par_block) && useSlopes){
		x += sign(hspd);
		y += lengthdir_y(1, gravDir - 180);
	}
	else{
		hspd = 0;
		if (destroyOnCollision) // Deleting the object
			instance_destroy(self);
	}
}
// Vertical collision
repeat(abs(vspd)){
	if (!place_meeting(x, y + sign(vspd), par_block) || !stopMovement){
		y += sign(vspd);
	}
	else{
		vspd = 0;
		if (destroyOnCollision) // Deleting the object
			instance_destroy(self);
	}
}