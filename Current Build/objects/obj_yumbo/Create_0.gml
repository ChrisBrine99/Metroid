/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.6, 4, 0.2, 0, 0, 270);

// Modify the hp and damage variables
hitpoints = 4;		// How much damage the entity can take
damage = 8;			// How much damage the entity causes Samus upon collision

// Set it to move in a random direction
scr_random_dir();

// Variables specific to Yumbo
turnTimer = 45;
up = false;
down = false;
origY = y;

// Make the Yumbo weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;