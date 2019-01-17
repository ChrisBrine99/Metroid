/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1, 5.5, 1, 0, 0.15, 270);

// Set it to move in a random direction
scr_random_dir();

// Modify the hp and damage variables
hitpoints = 4;
damage = 10;

// Make the waver to be weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;

// Waver specific variables
up = false;
down = false;
dirTimer = 0;