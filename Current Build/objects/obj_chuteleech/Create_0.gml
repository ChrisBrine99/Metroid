/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(2.4, 1, 0.15, -6.3, 0.2, 270);

// Modify the hp and damage variables
hitpoints = 4;	// How much damage the entity can take
damage = 10;	// How much damage the entity causes Samus upon collision

// Hornoad specific variables
jumping = false;
cooldownTimer = 60;
dir = 1;

// Make the Hornoad weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;