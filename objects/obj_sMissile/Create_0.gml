/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 8;
maxVspd = 8;
accel = 0.5;
damage = 25;

// Play the Super Missile fire sound effect
 scr_play_sound(snd_sMissile_fire, 0, false, true);

// Set the explosion effect object
FXobj = obj_sMissile_collide;

// Set the blocks that the missile can destroy
blockToDestroy = DYNAMIC_BLOCK.SUPER_MISSILE;