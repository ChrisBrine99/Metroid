/// @description Initializing Variables
// You can write your code in this editor

// Call the animation creation script
scr_animation_create();

slowPlayer = true;		// If true, the player will be slown down upon collision
isContinuous = false;	// Determines whether or not the damage will act like colliding with an entity vs. sitting in lava
damage = 0;				// The damage this hazard will do to the player upon contact
dmgTimerMax = 30;		// How many frames there will be between the player taking damage
dmgTimer = 0;			// The timer that counts said frames

// The Ambient Light that comes with the hazard (Can be disabled)
ambLight = instance_create_depth(x, y, 45, obj_light_emitter);