/// @description Handles collision between a dynamic entity and a wall.
///	NOTE -- This script must be placed in the step event of an object in order to function.
/// @param hspd
/// @param vspd
/// @param onGround
/// @param gravDir
/// @param useSlopes
/// @param stopMovement
/// @param destroyOnCollision

var hspd, vspd, onGround, gravDir, useSlopes, stopMovement, destroyOnCollision;
hspd = argument0;
vspd = argument1;
onGround = argument2;
gravDir = argument3;
useSlopes = argument4;
stopMovement = argument5;
destroyOnCollision = argument6;

// Don't check for collisions outside of the object's step event
if (event_type != ev_step){
	return;	
}

// Horizontal Collision
repeat(round(abs(hspd))){
	if (!place_meeting(x + sign(hspd) * global.deltaTime, y + lengthdir_y(1, gravDir), par_block) && onGround && useSlopes){
		x += sign(hspd) * global.deltaTime;
		y += lengthdir_y(1, gravDir);
	} else if (!place_meeting(x + sign(hspd) * global.deltaTime, y, par_block) || (!stopMovement && !destroyOnCollision)){
		x += sign(hspd) * global.deltaTime;
	} else if (!place_meeting(x + sign(hspd) * global.deltaTime, y + lengthdir_y(1, gravDir - 180), par_block) && useSlopes){
		x += sign(hspd) * global.deltaTime;
		y += lengthdir_y(1, gravDir - 180);
	} else{
		// Deleting the object if it is destroyed upon collision
		if (destroyOnCollision){
			var block = instance_place(x + sign(hspd), y, par_block);
			if (block.isGeneric) {instance_destroy(self);}
		} else{
			// Stopping horizontal movement
			self.hspd = 0;
		}
	}
}
// Vertical collision
repeat(round(abs(vspd))){
	if (!place_meeting(x, y + sign(vspd) * global.deltaTime, par_block) || (!stopMovement && !destroyOnCollision)){
		y += sign(vspd) * global.deltaTime;
	} else{
		// Deleting the object if it is destroyed upon collision
		if (destroyOnCollision){
			var block = instance_place(x, y + sign(vspd), par_block);
			if (block.isGeneric) {instance_destroy(self);}
		} else{
			// Stopping vertical movement
			self.vspd = 0;
		}
	}
}