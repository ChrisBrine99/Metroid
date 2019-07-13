/// @description Initializing all the necessary variables
// You can write your code in this editor

// Set some default characteristics (max speed of 6; no acceleration needed to reach said speed)
scr_entity_create(6, 6, 6, 0, 0, 270);

// Some unique variables for projectiles fired by the player
blockToDestroy = DYNAMIC_BLOCK.NORMAL;	// The default block that the projectile can destroy
damage = 1;								// The damage the projectile causes on collision
destroyOnWallCollide = true;			// If true, the projectile won't phase through walls
destroyOnEntityCollide = true;			// If false, the projectile will be able to go through other entities
offsetX = 0;							// The offset on the x-axis from the entity's origin
offsetY = 0;							// The offset on the y-axis from the entity's origin
destroyFX = true;						// If true, an explosion effect will spawn
FXobj = noone;							// The object that will be used for the destroy effect

// Correctly setting the position of the projectile
visible = false;
alarm[0] = 1;