/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();
// Edit some variables for the Wave Beam
increment = 4;
maxAmplitude = increment * 2;
movingUp = false;

// The new damage and speed variables
maxHspd = 11;
maxVspd = 11;
damage = 2;

// Enable the Wave Beam to pass through walls
destroyOnWallCollide = false;

// Modify what door the Wave Beam can open
primaryDoor = DOOR_TYPE.WAVE;	

// Play the Wave Beam sound effect
scr_play_sound(snd_wave_beam, 0, false, true);

// Altering the ambient light's color
ambLight.lightCol = c_fuchsia;