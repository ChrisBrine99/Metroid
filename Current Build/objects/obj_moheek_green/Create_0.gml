/// @description Initializing the entity
// You can write your code in this editor

// Set the speed and image speed
spd = choose(-0.7, 0.7);
imgSpd = 3.4;
spr = spr_moheek1;

// Call the parent create event
event_inherited();

// Modify the hp and damage variables
hitpoints = 12;	// How much damage the entity can take
damage = 40;	// How much damage the entity causes Samus upon collision