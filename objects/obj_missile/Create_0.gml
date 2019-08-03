/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 6;
maxVspd = 6;
accel = 0.5;
damage = 5;

// Set the explosion effect object
FXobj = obj_missile_collide;

// Modify what door the Missile can open
primaryDoor = DOOR_TYPE.MISSILE;

// Play the Missile fire sound effect
scr_play_sound(snd_missile_fire, 0, false, true);

// Set the blocks that the missile can destroy
blockToDestroy = DYNAMIC_BLOCK.MISSILE;