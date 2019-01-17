/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.5, 5, 0, 0, 0, 270);

// Set it to move in a random direction
scr_random_dir();

// Modify the hp and damage variables
hitpoints = 8;		// How much damage the entity can take
damage = 16;		// How much damage the entity causes Samus upon collision

attacking = false;
readyingAttack = false;
countdown = 10;

// Make the Rio weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;