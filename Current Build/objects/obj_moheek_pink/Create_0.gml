/// @description Initializing the entity
// You can write your code in this editor

// Set the speed and image speed
spd = choose(-0.5, 0.5);
imgSpd = 1;
spr = spr_moheek0;

// Call the parent create event
event_inherited();

// Modify the hp and damage variables
hitpoints = 2;		// How much damage the entity can take
damage = 8;		// How much damage the entity causes Samus upon collision