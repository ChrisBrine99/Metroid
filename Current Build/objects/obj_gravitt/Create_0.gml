/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1, 0, 0.2, 0, 0, 270);
onGround = true;

// Create the enemy shield instance
s = instance_create_depth(x - (sprite_width / 2) + 1, y - 7, depth, obj_enemy_shield);
s.image_xscale = sprite_width - 2;
s.image_yscale = 8;

// Gravitt specific variables
cooldownTimer = 120;
turnTimer = 120;
inGround = false;
risingUp = false;
startY = y;

// Modify the hp and damage variables
hitpoints = 8;		// How much damage the entity can take
damage = 40;		// How much damage the entity causes Samus upon collision

// Make the Gravitt weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;