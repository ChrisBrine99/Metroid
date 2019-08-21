/// @description Handles collision between a dynamic entity and a wall.
///	NOTE -- This script must be placed in the step event of an object in order to function.
/// @param hspd
/// @param vspd
/// @param onGround
/// @param gravDir
/// @param useSlopes
/// @param stopMovement
/// @param destroyOnCollision

var hspd, vspd, onGround, gravDir, useSlopes, stopMovement, destroyOnCollision, dHspd, dVspd;
hspd = argument0;						// The current horizontal speed of the object
vspd = argument1;						// The current vertical speed of the object
onGround = argument2;					// If false, the object is currently airbourne
gravDir = argument3;					// The direction that the gravity will pull the object toward
useSlopes = argument4;					// If true, the object should be able to move up and down slopes
stopMovement = argument5;				// If true, the object will be stopped upon collision
destroyOnCollision = argument6;			// If true, the object will be destroyed upon collision
dHspd = sign(hspd) * global.deltaTime;	// The exact horizontal value in pixels the object moves in a frame		
dVspd = sign(vspd) * global.deltaTime;	// The exact vertical value in pixels the object moves in a frame

// Don't check for collisions outside of the object's step event
if (event_type != ev_step){
	return;	
}

// Horizontal Collision
repeat(round(abs(hspd))){
	if (onGround && useSlopes){ // Check for slopes
		var yMove = lengthdir_y(1, gravDir);
		if (!place_meeting(x + dHspd, y + yMove, par_block)){ // Moving down a slope
			x += dHspd;
			y += yMove;
			break;
		} else if (place_meeting(x + dHspd, y, par_block) && !place_meeting(x + dHspd, y - yMove, par_block)){ // Moving up a slope
			x += dHspd;
			y -= yMove;
			break;
		}
	}
	if (!place_meeting(x + dHspd, y, par_block) || (!stopMovement && !destroyOnCollision)){ // Moving horizontally
		x += dHspd;
	} else{
		if (destroyOnCollision){ // Deleting the object if it is destroyed upon collision
			var block = instance_place(x + sign(hspd), y, par_block);
			if (block.isGeneric) {instance_destroy(self);}
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
			var block = instance_place(x, y + sign(vspd), par_block);
			if (block.isGeneric) {instance_destroy(self);}
		} else{ // Stopping vertical movement if the object doesn't destroy itself
			self.vspd = 0;
		}
	}
}