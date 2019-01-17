/// @description Default Variables
// You can write your code in this editor

scr_entity_create(0, 0, 0, 0, 0, 270);

hitpoints = -255;		// How much damage the entity can take
damage = 0;				// How much damage the entity causes Samus upon collision

frozen = false;
frozenTimer = 600;
block = 0;

hit = false;
timer = 5;

buffer = 64;			// How many pixels off screen an AI needs to be in order to activate

// Note -- All enemies are weak to the power bomb because of its absurd power.
weakToBeams = false;	// If true, the enemy will take damage from Samus's beam
weakToMissiles = false;	// If true, the enemy will take damage from regular missiles
weakToSMissiles = false;// If true, the enemy will take damage from super missiles
weakToBombs = false;	// If true, the enemy will take damage from regular bombs

invulnerable = false;	// If true, the enemy will not recieve damage from anything