/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;

#endregion

#region VARIABLES BORROWED FROM par_entity

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = -1;
lastState = -1;

// The weapon's current horizontal and vertical movement velocity, respectively.
hspd = 0;
vspd = 0;

// The entity's horizontal acceleration (accel) and their vertical acceleration (grav).
accel = 0;
grav = 0;
// NOTE -- hspd still uses accel for movement, and grav is used for vertical movement, and not gravity.
// The names have to be the same so set_velocity_speed still works with this object.

// These four variables assist with movement and delta timing. The first two store the difference in horizontal
// and vertical movement during that frame, respectively. Then, the fractional values from those two variables
// are stored in their relative fraction variables, which are re-applied whenever the fraction value surpassed
// a whole number. This allows for movement at any variable frame rate to be accurate and consistent.
deltaHspd = 0;
deltaVspd = 0;
hspdFraction = 0;
vspdFraction = 0;

// Stores the current maximum possible horizontal and vertical velocities for the entity. These are different
// from their respective const variables so that these can be altered without ever losing the initial values.
maxHspd = 0;
maxVspd = 0;

// Stores the instance ID for the ambient light that is following the current entity around. The position 
// is the light's offset relative to the position of the entity itself.
ambLight = noone;
lightPosition = [0, 0];

// A flag that determines if the projectile is destroyed or not at the beginning of the next frame.
isDestroyed = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Three unique variables to all weaponry that Samus can use. The first variable is the object that is created
// as an explosion effect whenever the wepaon collides with the world or an enemy or vice versa. Next, the
// damage is how many hitpoints the target loses relative to their damage resistance. Finally, the lifespan
// determines how many frames the weapon is active for before it explodes. (Ex. Bombs)
collideEffect = noone;
damage = 0;
lifespan = -1;

// A 2D vector that can have the values [1, 0], [-1, 0], [0, 1], and [0, -1]. These values will determine
// the direction the projectile moves in, which is one of those four possible values.
inputDirection = NO_MOVEMENT;

// Determines what happens to an entity when the projectile collides with them.
projectileType = -1;

// Two flags to determine if the projectile will be destroyed by walls or entities whenever a collision with
// either occurs. This means that the entity/projectile collision won't take a flag to destroy itself upon
// collision with another entity.
destroyOnWallCollide = false;
destroyOnEntityCollide = false;

#endregion