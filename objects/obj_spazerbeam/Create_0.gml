/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 8;
maxVspd = 8;
damage = 3;

// Unique variables for the Spazer Beam
increment = 2;
maxAmplitude = increment * 3;
movingUp = false;

// Play the Spazer Beam sound effect
scr_play_sound(snd_spazer_beam, 0, false, true);

// Enable the Spazer Beam to pass through walls
destroyOnWallCollide = false;

// Altering the ambient light's color
ambLight.lightCol = c_lime;