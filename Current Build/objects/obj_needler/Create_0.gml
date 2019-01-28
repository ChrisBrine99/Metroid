/// @description Initializing the entity
// You can write your code in this editor

// Call the parent create event
event_inherited();

// Modify the movement variables a little
scr_entity_create(0, 7, 0, 0, 0.25, 270);

if (object_get_name(object_index) == "obj_needler"){
	// Set the speed and image speed
	spd = choose(-0.5, 0.5);
	imgSpd = 1;
	spr = spr_needler0;
}
turnAngle = 90;

// Modify the hp and damage variables
hitpoints = 18;		// How much damage the entity can take
damage = 60;		// How much damage the entity causes Samus upon collision

if (spd < 0) image_xscale = -1;
direction = 0;
sprite_index = spr_needler0;

// Make the Needler weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;