/// @description Initializing the entity
// You can write your code in this editor

// Set the speed and image speed
spd = choose(-0.4, 0.4);
imgSpd = 2.5;
spr = spr_tsumuri0;

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(0, 2.5, 0, 0, 0.25, 270);

// Modify the hp and damage variables
hitpoints = 4;	// How much damage the entity can take
damage = 12;	// How much damage the entity causes Samus upon collision

// Make the Tsumuri weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;