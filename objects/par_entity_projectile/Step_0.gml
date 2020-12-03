/// @description Non-State Code/Calling State Code

// Counting down the projectile's lifespan 
if (lifespan != -1){
	lifespan -= global.deltaTime;
	if (lifespan <= 0){
		instance_destroy(self);
	}
}

// Call the projectile's current state
if (curState != -1){
	script_execute(curState);
}

// First, check for collision between the projectile and any entities it may hit inbetween its current position
// and the position it will be in at the start of the next frame.
entity_projectile_collision();
// Next, update the projectile's position; since projectiles will always be moving.
update_position_projectile();