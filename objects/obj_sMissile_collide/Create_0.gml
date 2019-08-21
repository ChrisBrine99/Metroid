/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Play the Super Missile Explosion sound effect
scr_play_sound(snd_sMissile_collide, 0, false, true);

// Create and alter the ambient light source
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 90;
	yRad = 90;
	lightCol = c_fuchsia;
}
flashingTime = 1;