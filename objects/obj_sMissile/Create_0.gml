/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 8;
maxVspd = 8;
accel = 0.5;
damage = 25;

// Set the explosion effect object
FXobj = obj_sMissile_collide;

// Modify what doors the Super Missile can open
primaryDoor = DOOR_TYPE.SUPER_MISSILE;
secondaryDoor = DOOR_TYPE.MISSILE;

// Play the Super Missile fire sound effect
scr_play_sound(snd_sMissile_fire, 0, false, true);

// Set the blocks that the missile can destroy
blockToDestroy = DYNAMIC_BLOCK.SUPER_MISSILE;

// Remove the Ambient Light Source
with(ambLight) {instance_destroy(self);}
ambLight = noone;