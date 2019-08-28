/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();
// Edit some variables for the Spazer Beam
increment = 2;
maxAmplitude = increment * 3;
movingUp = false;

// The new damage and speed variables
maxHspd = 8;
maxVspd = 8;
damage = 3;

// Enable the Spazer Beam to pass through walls
destroyOnWallCollide = false;

// Modify what door the Spazer Beam can open
primaryDoor = DOOR_TYPE.SPAZER;

// Play the Spazer Beam sound effect
scr_play_sound(snd_spazer_beam, 0, false, true);

// Altering the ambient light's color
ambLight.lightCol = c_lime;