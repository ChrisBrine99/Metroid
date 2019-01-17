/// @description Initializing the entity
// You can write your code in this editor

// Modify the movement variables a little
switch(type){
	case 0: // The Yellow Zeb
		scr_entity_create(2, 1, 0.5, 0, 0, 270);
		// Modify the hp and damage variables
		hitpoints = 2;		// How much damage the entity can take
		damage = 8;			// How much damage the entity causes Samus upon collision
		break;
	case 1: // The Red Zeb
		scr_entity_create(3.5, 2, 0.5, 0, 0, 270);
		// Modify the hp and damage variables
		hitpoints = 4;		// How much damage the entity can take
		damage = 16;		// How much damage the entity causes Samus upon collision
		sprite_index = spr_zeb1;
		break;
	case 2: // The Gawron
		scr_entity_create(2, 1, 0.5, 0, 0, 270);
		// Modify the hp and damage variables
		hitpoints = 12;		// How much damage the entity can take
		damage = 24;		// How much damage the entity causes Samus upon collision
		sprite_index = spr_gawron0;
		break;
	case 3: // The Yumee
		scr_entity_create(4, 3, 0.5, 0, 0, 270);
		// Modify the hp and damage variables
		hitpoints = 8;		// How much damage the entity can take
		damage = 40;		// How much damage the entity causes Samus upon collision
		sprite_index = spr_yumee0;
		break;
}

// Setting the direction depending on where Samus is
if (obj_samus.x < x){
	image_xscale = -1;
	left = true;
}
else{
	image_xscale = 1;
	right = true;
}

// Determines if the Zeb can move horizontally or not
moveToPlayer = false;
startY = y;

// Make the Zeb weak to everything
weakToBeams = true;
weakToMissiles = true;
weakToSMissiles = true;
weakToBombs = true;