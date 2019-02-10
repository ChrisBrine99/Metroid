/// @description Initializes all of Samus's variables
// You can write your code in this editor

// Initializing the shared entity variables
scr_entity_create(2.1, 7, 0.3, -5.5, 0.25, 270);

// Variables that affect sprites/movement abilities/collision masks
crouching = false;			// If true, Samus will crouch; changing her collision mask
standTimer = 8;				// How long it takes for Samus to stand when holding left or right while she is crouching
inMorphball = false;		// If true, Samus is inside her morphball; changing her collision mask
isShooting = false;			// Checks if Samus is shooting or not
cooldownTimer = 20;			// The time it takes for Samus to lower her weapon after firing it

// Fire rates for the various beam weapons
powerBeamFR = 1;
iceBeamFR = 6;
waveBeamFR = 15;
spazerBeamFR = 20;
plasmaBeamFR = 30;
counterFR = 0;		// The counter for the fire rates

// Stops Samus from moving
canMove = false;

// Variable for altering image speeds in the water/lava
imageSpdPen = 1;

// Variables for keyboard input stuff
downKeyPressed = false;
upKeyPressed = false;

// Variables for enemy collision
beenHit = false;
hitTimer = 0;

// Variable for making the morphball bounce
vspdRecoil = 0;

instance_create_depth(x, y, 1, obj_controller);
obj_controller.alarm[1] = 1;