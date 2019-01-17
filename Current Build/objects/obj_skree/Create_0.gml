/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.3, 6, 0, 0.5, 0, 270);

// Modify the hp and damage variables
hitpoints = 2;	// How much damage the entity can take
damage = 8;		// How much damage the entity causes Samus upon collision

// Skree specific variables
attacking = false;
deathTimer = 15;

// Make the Skree weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;