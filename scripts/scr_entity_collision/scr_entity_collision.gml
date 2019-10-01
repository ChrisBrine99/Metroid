/// @description Handles collision between a dynamic entity and a wall.
///	NOTE -- This script must be placed in the step event of an object in order to function.
/// @param useSlopes
/// @param stopMovement
/// @param destroyOnCollision

var useSlopes, stopMovement, destroyOnCollision, dHspd, dVspd, yMove;
useSlopes = argument0;					// If true, the object should be able to move up and down slopes
stopMovement = argument1;				// If true, the object will be stopped upon collision
destroyOnCollision = argument2;			// If true, the object will be destroyed upon collision
dHspd = sign(hspd) * global.deltaTime;	// The exact horizontal value in pixels the object moves in a frame		
dVspd = sign(vspd) * global.deltaTime;	// The exact vertical value in pixels the object moves in a frame

// Horizontal Collision
repeat(round(abs(hspd))){
	if (global.deltaTime > 1.01) {yMove = lengthdir_y(global.deltaTime, gravDir);}
	else {yMove = lengthdir_y(1, gravDir);}
	if (onGround && useSlopes && !place_meeting(x + dHspd, y + yMove, par_block)){ // Moving down a slope
		x += dHspd;
		y += yMove;
	} else if (!place_meeting(x + dHspd, y, par_block) || (!stopMovement && !destroyOnCollision)){ // Moving horizontally
		x += dHspd;
	} else if (useSlopes && !place_meeting(x + dHspd, y - yMove, par_block)){ // Moving down a slope
		x += dHspd;
		y -= yMove;
	} else{
		if (destroyOnCollision){ // Deleting the object if it is destroyed upon collision
			var block = instance_place(x + dHspd, y, par_block);
			if (block.isGeneric) {instance_destroy(other);}
		} else{ // Stopping horizontal movement if the object doesn't destroy itself
			self.hspd = 0;
		}
	}
}

// Vertical collision
repeat(round(abs(vspd))){
	if (!place_meeting(x, y + dVspd, par_block) || (!stopMovement && !destroyOnCollision)){
		y += dVspd;
	} else{
		if (destroyOnCollision){ // Deleting the object if it is destroyed upon collision
			var block = instance_place(x, y + dVspd, par_block);
			if (block.isGeneric) {instance_destroy(other);}
		} else{ // Stopping vertical movement if the object doesn't destroy itself
			self.vspd = 0;
		}
	}
}