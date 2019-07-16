/// @decsription Creates the necessary variables for a dynamic entity (Ex. A Player Object, Enemy AI, NPCs, etc.)
/// @param maxHspd
/// @param maxVspd
/// @param accel
/// @param jumpSpd
/// @param grav
/// @param gravDir

// Initializing the entity variables
hspd = 0;				// Horizontal speed
vspd = 0;				// Vertical speed
hspdPenalty = 0;		// Horizontal movement penalty
vspdPenalty = 0;		// Vertical movement penalty

maxHspd = argument0;	// Max horizontal speed
maxVspd = argument1;	// Max vertical speed
accel = argument2;		// Horizontal acceleration
jumpSpd = argument3;	// Vertical jump speed

// Initializing the gravity variables
grav = argument4;		// Holds the gravity intensity (0.25 is the normal)
gravDir = argument5;	// Holds what direction the gravity is pulling (270 is downward, 90 is upward)

// The entity's health and lives variables
curHitpoints = 0;		// The entity's current health
maxHitpoints = 0;		// The maximum health that the entity can have
curLives = 0;			// The entity's current amount of lives
maxLives = 0;			// The maximum lives that the entity can have

// The entity's total damage resitance from hazards
damageRes = 1;			// 1 = full damage, 0.5 = half damage, etc.

// The image speed penalty for various entities 
imageSpdPen = 1;		// 1 = no penalty, 0.5 = half speed, etc.

// Variables for collision with hazards
beenHit = false;		// If true, the entity will be temporarily invulnerable
hitTimer = 0;			// The time in frames before the entity can be hit again

// Variables to know what state the entity is currently in
onGround = false;		// Whether or not the object is on the ground
right = false;			// Lets us know if the object is moving left
left = false;			// Lets us know if the object is moving right
up = false;				// If true, the entity is moving upward
down = false;			// If true, the entity is moving downward
canMove = true;			// If false, the entity will stop updating

// Variables for the ambient light that can surround certain entities
ambLight = noone;		// The unique instance ID for this object's ambient light
xOffset = 0;			// The offset on the x-axis that the light should be placed at
yOffset = 0;			// The offset on the y-axis that the light should be placed at