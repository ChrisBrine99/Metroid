/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.3, 7, 0, -6.5, 0.25, 270);

// Modify the hp and damage variables
hitpoints = 16;	// How much damage the entity can take
damage = 30;	// How much damage the entity causes Samus upon collision

// Sidehopper specific variables
readyingJump = false;
readyingTimer = 10;
jumping = false;
cooldownTimer = 60;

if (image_yscale < 0) gravDir = 90;

// Make the Sidehopper weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;