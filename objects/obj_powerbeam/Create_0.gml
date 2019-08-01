/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 9;
maxVspd = 9;
damage = 1;

// Play the Power Beam sound effect
scr_play_sound(snd_power_beam, 0, false, true);

// Set the explosion effect object
FXobj = obj_powerbeam_collide;

// Altering the ambient light's color
ambLight.lightCol = make_color_rgb(255, 250, 165);