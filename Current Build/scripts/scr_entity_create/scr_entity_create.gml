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
jumpSpd = argument3;	// Entity's jump height

// Initializing the gravity variables
grav = argument4;		// Holds the gravity intensity (0.25 is the normal)
gravDir = argument5;	// Holds what direction the gravity is pulling (270 is downward, 90 is upward)

// Variables to know what state the entity is currently in
onGround = false;		// Whether or not the object is on the ground
jumping = false;		// If true, the object is jumping
jumpspin = false;		// If true, the object is somersaulting OR using a secondary jumping type.
right = false;			// Lets us know if the object is moving left
left = false;			// Lets us know if the object is moving right
up = false;				// If true, the entity is moving upward (Or aiming up for Samus)
down = false;			// If true, the eneityt is moving downward (Or aiming down for Samus)
canMove = true;			// If false, the entity will stop updating