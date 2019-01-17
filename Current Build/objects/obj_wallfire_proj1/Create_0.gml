/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Call the entity create script
scr_entity_create(2, 7, 0, 0, 0.25, 270);

// Modify the damage variable
damage = noone;

// Variables specific to the wallfire's bomb projectile
vspdRecoil = 0;
timer = 120;

// Make the projectile invulnerable
invulnerable = true;