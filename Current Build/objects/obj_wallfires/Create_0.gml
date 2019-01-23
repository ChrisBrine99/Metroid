/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(0, 3, 0, 0, 0, 270);
vspdPenalty = 2;

// Modify the health and damage variables a little
damage = 4;

// Variables specifically for the wallfires
hasFired = true;
cooldownTimerMax = 100;
cooldownTimer = 60 + floor(random(120));
numFired = 0;

isActive = false;
offset = 120;

// Shield for the bottom of the wallfire
shieldSizeX = sprite_width;
shieldSizeY = 6;
s = instance_create_depth(x, y + (sprite_height / 2) - 3, depth, obj_enemy_shield);
s.image_xscale = shieldSizeX;
s.image_yscale = shieldSizeY;

down = choose(true, false);
up = false;
if (!down)
	up = true;

// Make the wallfires weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;