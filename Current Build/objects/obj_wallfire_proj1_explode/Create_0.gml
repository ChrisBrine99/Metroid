/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Call the entity create script
scr_entity_create(0, 0, 0, 0, 0, 270);

// Modify the damage variable
damage = 8;

// Make the projectile invulnerable
invulnerable = true;

audio_play_sound(snd_bomb_explode, 1, false);