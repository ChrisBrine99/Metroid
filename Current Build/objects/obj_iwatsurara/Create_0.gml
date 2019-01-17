/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(0, 7, 0, 0, 0.25, 270);

// Modify the hp and damage variables
hitpoints = 2;	// How much damage the entity can take
damage = 8;	// How much damage the entity causes Samus upon collision

// Variable specific to the Iwatsurara
isFalling = false;
despawnTimer = 40;

// Make the Iwatsurara weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;