/// @description Insert description here
// You can write your code in this editor

switch(setIndex){
	case 0: // Powerbeam explosion
		sprite_index = spr_powerbeam_explode;
		break;
	case 1: // Icebeam explosion
		sprite_index = spr_powerbeam_explode;
		//sprite_index = spr_icebeam_explode;
		break;
	case 2: // Wavebeam explosion
		sprite_index = spr_powerbeam_explode;
		// sprite_index = spr_wavebeam_explode;
		break;
	case 3: // Spazerbeam explosion
		sprite_index = spr_powerbeam_explode;
		// sprite_index = spr_spazerbeam_explode;
		break;
}
mask_index = sprite_index;