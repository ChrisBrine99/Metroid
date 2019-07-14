/// @description Checking for collision with the required projectile/bomb/entity.
// You can write your code in this editor

// Freeze the block if the game is paused
if (global.gameState == GAME_STATE.PAUSED){
	checkForCollision = false;
	return;	
}

// Determining if the block is within the player's view
if (global.camX - 32 < x && global.camY - 32 < y && global.camX + global.camWidth + 16 > x && global.camY + global.camHeight + 16 > y){
	checkForCollision = true;
} else{ // Disable collision checking when off-screen
	checkForCollision = false;
}

if (!isDestroyed){
	mask_index = sprite_index;
	if (checkForCollision){
		// Loop through all possible entities that can destroy this block
		for (var i = 0; i < entityNum; i++){
			if (setObject[i] != noone){
				// Checking for collision between the block and the objects that can destroy it
				if (instance_exists(setObject[i])){
					var obj = instance_nearest(x, y, setObject[i]);
					if (place_meeting(x - sign(obj.hspd), y - sign(obj.vspd), obj)){
						if (destroyTimerMax > 0){
							isDestroyed = true;
							destroyTimer = destroyTimerMax;
						} else{
							instance_destroy(self);
						}
						// Create the block destroying effect
						instance_create_depth(x, y, depth, obj_dblock_destroy);
						// Destory the setObject if they are destroyed on walls. (Projectiles only)
						if (variable_instance_exists(obj, "destroyOnWallCollide")){
							if (obj.destroyOnWallCollide) {instance_destroy(obj);}	
						}
					}
				} 
			}
		}
		// Check for collisions with generic projectiles
		if (instance_exists(par_projectile)){
			var proj = instance_nearest(x, y, par_projectile);
			if (place_meeting(x - sign(proj.hspd), y - sign(proj.vspd), proj)){
				if (proj.destroyOnWallCollide) {instance_destroy(proj);}
			}
		}
	}
} else{
	mask_index = spr_dblock_destroyed;
	// Countdown until the block regerates
	if (destroyTimer > 0){
		destroyTimer--;
		// Regenerate the block
		if (destroyTimer == 0){
			var effect = instance_create_depth(x, y, depth, obj_dblock_regen);
			effect.spawnerId = id;
		}
	}
}