/// @description Insert description here
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the hp and damage variables
hitpoints = 5;	// How much damage the entity can take
damage = 12;	// How much damage the entity causes Samus upon collision

// Variables specific to Gullug
speed = choose(1.5, -1.5);
spd = speed;

// Make the Gullug weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;