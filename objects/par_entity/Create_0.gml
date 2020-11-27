/// @description Variable Initialization

#region UNIQUE VARIABLE INITIALIZATION

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = -1;
lastState = -1;

// The entity's current horizontal and vertical movement velocity, respectively.
hspd = 0;
vspd = 0;

// The entity's horizontal acceleration (accel) and their vertical acceleration (grav). On top of that, the
// flag isGrounded is used to check whether or not the entity in airbourne or not.
accel = 0;
grav = 0;
isGrounded = false;

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

// The CONSTANT value for the entity's maximum hspd and vspd, which cannot be adjusted by movement speed buffs
// and debuffs. However, they can be explicitly change if required through the set_max_move_speed method.
maxHspdConst = 0;
maxVspdConst = 0;

// The variables that keep track of the current hitpoints, maximum hitpoints, as well as damage resistance
// from attacks. The damage resistance is multiplied with recieved damage to calculte the total damage. A
// lower value results in lower damage taken. (1 = full damage, 0.6 = 60% damage taken)
hitpoints = 0;
maxHitpoints = 0;
damageResistance = 1;

// Variables for controlling the entity's health regeneration. The first value corresponds to the amount of
// hitpoints gained, and the last variable determines how many seconds of real-time need to pass before the
// entity gains said amount of health. Finally, the fraction variable store the fractional value for the
// amount of health regained. Once that value passes 1, the floored value will be gained as health and
// subtracted from the fraction value.
hpRegenAmount = 0;
hpRegenFraction = 0;
regenSpeed = 0;

// Two flags that determines whether or not the entity can take damage and be killed or if they have had
// their hitpoints reduced to 0; killing them at the start of the next frame.
isInvincible = false;
isDestroyed = false;

// A flag that grants the entity temporary invincibility frames after getting hit by an enemy's attack.
// The time in frames (1 frame = 1/60 seconds) is variable and can be set to any amount of time. The final
// variable is the script that is called upon the entity being hit.
isHit = false;
timeToRecover = 0;
recoveryTimer = 0;
hitScript = -1;

// These variables handle animating the entity using delta time. Since image_speed can act really weird
// depending on the framerate; these variables take care of what image_speed would normally do, but in a
// frame-independent manner.
curFrame = 0;
spriteIndex = 0;
spriteNumber = 0;
spriteSpeed = 0;
transitionSprite = -1;
transitionNumber = 0;
transitionSpeed = 0;

// Stores the instance ID for the ambient light that is following the current entity around. The position 
// is the light's offset relative to the position of the entity itself.
ambLight = noone;
lightPosition = [0, 0];

// Stores the list of projectiles that cause damage to the entity. If any of the types match, damage is dealt, 
// but if no types match, the collision check will be ignored. The lastHitProjectile variable below holds the 
// ID for the projectile that last hit the entity, so that damage isn't done twice if a collision occurs
// two times before the projectile exits the entity.
projectileWeakness = ds_list_create();
lastHitProjectile = noone;

#endregion