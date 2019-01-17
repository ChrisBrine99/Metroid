/// @description Initializes variables for velocity
// You can write your code in this editor

// Initializing the shared entity variables
scr_entity_create(8, 8, 0.5, 0, 0.5, 270);

// Setting the position of the arm cannon
scr_find_arm_cannon();

setIndex = global.curEquipmentIndex;

// Delete the object if Samus has no missiles/super missiles
if (setIndex == 1){
	if (global.missiles <= 0){
		canExplode = false;
		instance_destroy(self);
	}
}
else if (setIndex == 2){
	if (global.sMissiles <= 0){
		canExplode = false;
		instance_destroy(self);
	}
}

// Setting the sprite and damage of the beam being fired
switch(setIndex){
	case 1: // Regular Missile
		damage = 4;
		sprite_index = spr_missile;
		if (global.missiles > 0){
			global.missiles--;
			// Stop the sound from overlapping
			if (audio_is_playing(snd_missile)) audio_stop_sound(snd_missile);
			audio_play_sound(snd_missile, 0, false);
		}
		break;
	case 2: // Super Missile
		damage = 20;
		sprite_index = spr_sMissile;
		if (global.sMissiles > 0){
			global.sMissiles--;
			// Stop the sound from overlapping
			if (audio_is_playing(snd_sMissile)) audio_stop_sound(snd_sMissile);
			audio_play_sound(snd_sMissile, 0, false);
		}
		break;
}
canExplode = true;