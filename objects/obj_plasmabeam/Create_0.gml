/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 13;
maxVspd = 13;
damage = 16;

// Enable the Plasma Beam to pass through walls and entities
destroyOnWallCollide = false;
destroyOnEntityCollide = false;

// Play the Plasma Beam sound effect
scr_play_sound(snd_plasma_beam, 0, false, true);

// Altering the ambient light's color
ambLight.lightCol = c_red;