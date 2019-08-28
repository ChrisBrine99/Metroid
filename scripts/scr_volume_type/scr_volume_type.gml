/// @description Gets what volume level will effect the current sound being looked for.
/// @param soundID

var soundID, masterVolume, volume;
soundID = argument0;
masterVolume = global.oAudio[0] / 100;
volume = 100;

switch(soundID){
	// Sounds affected by the Music Volume level
	case music_surface_sr388:
	case music_rocky_maridia:
	case music_brinstar:
	case music_item_room:
	case music_save_room:
	case music_unknown0:
	case music_item_fanfare:
	case music_samus_appears:
		if (!global.musicMuted) {volume = global.oAudio[1];}
		else {volume = 0;}
		break;
	// Sounds affected by the Player Sounds Volume level
	case snd_samus_walk:
	case snd_samus_jump:
	case snd_samus_crouch:
	case snd_samus_transform:
	case snd_samus_screw_attack:
	case snd_samus_hurt:
	case snd_samus_drown:
	case snd_samus_death:
		volume = global.oAudio[2];
		break;
	// Sounds affected by the Weapon Volume level
	case snd_power_beam:
	case snd_ice_beam:
	case snd_wave_beam:
	case snd_spazer_beam:
	case snd_plasma_beam:
	case snd_missile_fire:
	case snd_sMissile_fire:
	case snd_bomb_set:
		volume = global.oAudio[3];
		break;
	// Sounds affected by the Environment Volume level
	case snd_missile_collide:
	case snd_sMissile_collide:
	case snd_bomb_explode:
	case snd_projectile_ping:
	case snd_door:
		volume = global.oAudio[4];
		break;
	// Sounds affected by the GUI Volume level
	case snd_beam_select:
	case snd_missile_select:
		volume = global.oAudio[5];
		break;
}

return (volume / 100) * masterVolume;