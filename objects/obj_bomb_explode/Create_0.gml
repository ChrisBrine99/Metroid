/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Play the Bomb Explosion sound effect
scr_play_sound(snd_bomb_explode, 0, false, true);

// Create and alter the ambient light source
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);
with(ambLight){
	xRad = 40;
	yRad = 40;
	lightCol = c_aqua;
}
flashingTime = 1;