/// @description Initializing the Multiviola
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the entity variable a little
scr_entity_create(2, 2, 0, 0, 0, 270);

// Modify the hp and damage variables
hitpoints = 12;	// How much damage the entity can take
damage = 24;	// How much damage the entity causes Samus upon collision

up = choose(false, true);
down = !up;
right = choose(false, true);
left = !right;
imgDir = 0;