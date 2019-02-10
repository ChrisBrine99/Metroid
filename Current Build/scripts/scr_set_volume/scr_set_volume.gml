/// @description Sets the volumes for all sound effects in the game.

var vol;
vol = global.option[4] / 100;

// Setting volume for Samus's sound effects
audio_sound_gain(snd_samus_run, vol, 0);
audio_sound_gain(snd_samus_jump, vol, 0);
audio_sound_gain(snd_samus_hit, vol, 0);
audio_sound_gain(snd_samus_die, vol, 0);
audio_sound_gain(snd_samus_crouch, vol, 0);
audio_sound_gain(snd_samus_transform, vol, 0);
audio_sound_gain(snd_samus_screwattack, vol, 0);

// Setting volume for projectile sound effects
audio_sound_gain(snd_powerbeam, vol, 0);
audio_sound_gain(snd_icebeam, vol, 0);
audio_sound_gain(snd_wavebeam, vol, 0);
audio_sound_gain(snd_spazerbeam, vol, 0);
audio_sound_gain(snd_plasmabeam, vol, 0);
audio_sound_gain(snd_missile, vol, 0);
audio_sound_gain(snd_sMissile, vol, 0);
audio_sound_gain(snd_missile_explode, vol, 0);
audio_sound_gain(snd_sMissile_explode, vol, 0);

// Setting volume for any other sound effects
audio_sound_gain(snd_enemy_hit, vol, 0);
audio_sound_gain(snd_enemy_die, vol, 0);
audio_sound_gain(snd_bomb_deploy, vol, 0);
audio_sound_gain(snd_bomb_explode, vol, 0);
audio_sound_gain(snd_equip_select, vol, 0);
audio_sound_gain(snd_beam_select, vol, 0);
audio_sound_gain(snd_health_pickup, vol, 0);
audio_sound_gain(snd_ammo_pickup, vol, 0);
audio_sound_gain(snd_door, vol, 0);
audio_sound_gain(snd_door2, vol, 0);
audio_sound_gain(snd_thunder, vol, 0);
audio_sound_gain(snd_pause, vol, 0);