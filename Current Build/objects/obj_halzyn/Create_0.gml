/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(1.5, 4, 0.25, 0, 0.5, 270);

// Create the two enemy shields position variables
sPos = 6;
shieldSizeX = 9;
shieldSizeY = 18;
s0 = instance_create_depth(x - (sPos + shieldSizeX), y - 1, depth, obj_enemy_shield);
s0.image_xscale = shieldSizeX;
s0.image_yscale = shieldSizeY;
s1 = instance_create_depth(x + sPos, y - 1, depth, obj_enemy_shield);
s1.image_xscale = shieldSizeX;
s1.image_yscale = shieldSizeY;

// Other Halzyn specific variables
turnTimer = 100;
up = true;
down = false;

// Set direction based on where Samus is
if (obj_samus.x <= x) left = true;
else right = true;

// Modify the hp and damage variables
hitpoints = 8;		// How much damage the entity can take
damage = 40;		// How much damage the entity causes Samus upon collision

direction = 0;

// Make the Halzyn weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;