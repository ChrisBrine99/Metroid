/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.3, 7, 0, -4.5, 0.25, 270);

// Modify the hp and damage variables
hitpoints = 6;	// How much damage the entity can take
damage = 10;	// How much damage the entity causes Samus upon collision

// Hornoad specific variables
jumping = false;
cooldownTimer = 45;

// Make the Hornoad weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;