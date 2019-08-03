/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 7;
maxVspd = 7;
damage = 1;

// Modify what door the Ice Beam can open
primaryDoor = DOOR_TYPE.ICE;	

// Play the Ice Beam sound effect
scr_play_sound(snd_ice_beam, 0, false, true);

// Altering the ambient light's color
ambLight.lightCol = c_aqua;