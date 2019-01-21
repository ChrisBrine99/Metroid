/// @description Insert description here
// You can write your code in this editor

event_inherited();

if (audio_is_playing(snd_missile_explode)) audio_stop_sound(snd_missile_explode);
audio_play_sound(snd_missile_explode, 1, false);