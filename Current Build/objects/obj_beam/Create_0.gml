/// @description Initializes variables for velocity
// You can write your code in this editor

// Initializing the shared entity variables
scr_entity_create(0, 0, 0, 0, 0, 270);

// Setting the position of the arm cannon
scr_find_arm_cannon();

canExplode = true;

// Setting the sprite and damage of the beam being fired
setIndex = global.curBeamIndex;
switch(setIndex){
	case 0: // Powerbeam
		damage = 1;
		sprite_index = spr_powerbeam;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_powerbeam)) audio_stop_sound(snd_powerbeam);
		audio_play_sound(snd_powerbeam, 0, false);
		waveMotion = false;
		// Set the speed of the power beam
		maxHspd = 8;
		maxVspd = 8;
		break;
	case 1: // Icebeam
		damage = 1;
		sprite_index = spr_icebeam;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_icebeam)) audio_stop_sound(snd_icebeam);
		audio_play_sound(snd_icebeam, 0, false);
		waveMotion = false;
		// Set the speed of the ice beam
		maxHspd = 7;
		maxVspd = 7;
		break;
	case 2: // Wavebeam
		damage = 2;
		sprite_index = spr_wavebeam;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_wavebeam)) audio_stop_sound(snd_wavebeam);
		audio_play_sound(snd_wavebeam, 0, false);
		alarm[0] = 1;
		increment = 45;
		// Set the speed of the wave beam
		maxHspd = 6;
		maxVspd = 6;
		break;
	case 3: // Spazerbeam
		damage = 3;
		sprite_index = spr_spazerbeam;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_spazerbeam)) audio_stop_sound(snd_spazerbeam);
		audio_play_sound(snd_spazerbeam, 0, false);
		alarm[0] = 1;
		increment = 45;
		// Set the speed of the spazer beam
		maxHspd = 6;
		maxVspd = 6;
		break;
	case 4: // Plasmabeam
		damage = 16;
		sprite_index = spr_plasmabeam;
		// Stop the sound from overlapping
		if (audio_is_playing(snd_plasmabeam)) audio_stop_sound(snd_plasmabeam);
		audio_play_sound(snd_plasmabeam, 0, false);
		waveMotion = false;
		// Set the speed of the plasma beam
		maxHspd = 10;
		maxVspd = 10;
		break;
}