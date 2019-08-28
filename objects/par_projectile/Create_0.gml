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

// These variables allow the projectile to move in sparatic motions (Ex. waves, diamonds, spirals)
increment = 4;
maxAmplitude = increment * 2;
movingUp = false;

// Unique Variables for what doors the projectile can collide with
primaryDoor = DOOR_TYPE.NORMAL;			// The main door this projectile can unlock (Normal is a generic default)
secondaryDoor = DOOR_TYPE.NORMAL;		// The secondary door this projectile can unlock (Normal is a generic default)

// Correctly setting the position of the projectile
visible = false;
alarm[0] = 1;

// Creating the ambient light source
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 0;
	yRad = 0;
}