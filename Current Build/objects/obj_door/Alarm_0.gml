/// @description Setting the sprite and door type
// You can write your code in this editor

image_speed = 0;
switch(type){
	case -1: // Locked Door (Used for events)
		sprite_index = spr_disabled_door;
		break;
	case 0: // Blue Door (Anything opens it)
		sprite_index = spr_blue_door;
		break;
	case 1: // White Door (Only opens with the Ice Beam)
		sprite_index = spr_ice_door;
		break;
	case 2: // Pink Door (Only opens with the Wave Beam)
		sprite_index = spr_wave_door;
		break;
	case 3: // Green Door (Only opens with the Spazer Beam)
		sprite_index = spr_spazer_door;
		break;
	case 4: // Maroon Door (Only opens with the Plasma Beam)
		sprite_index = spr_plasma_door;
		break;
	case 5: // Missile Door (Only opens with Missiles/Super Missiles)
		sprite_index = spr_missile_door;
		if (global.mDoor[index] == true){ // Turn the door into a blue door if it has already been opened
			sprite_index = spr_blue_door;
			type = 0;
		}
		break;
	case 6: // Super Missile Door (Only opens with Super Missiles)
		sprite_index = spr_sMissile_door;
		if (global.smDoor[index] == true){ // Turn the door into a blue door if it has already been opened
			sprite_index = spr_blue_door;
			type = 0;
		}
		break;
	case 7: // Power Bomb Door (Only opens with Power Bombs)
		sprite_index = spr_pBomb_door;
		if (global.pDoor[index] == true){ // Turn the door into a blue door if it has already been opened
			sprite_index = spr_blue_door;
			type = 0;
		}
		break;
	case 8: // Disabled Door (Only opens when all enemies are defeated)
		sprite_index = spr_disabled_door;
		break;
}

if (distance_to_object(obj_samus) < 16){
	closing = true;
	image_index = 2;
}