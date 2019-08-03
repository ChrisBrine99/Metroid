/// @description Insert description here
// You can write your code in this editor

// The door's classification which will determine what can open it
doorType = DOOR_TYPE.NORMAL;

// Freeze the animation so it doesn't get destroyed instantly
image_speed = 0;

// If true, the door will be closing behind Samus
open = false;
// Check if the door needs to be opened
if (distance_to_object(obj_player) <= 16){
	image_index = 2;
	open = true;
}
// If true, the door will be opening from projectile/bomb collision
unlocked = false;

// Make sure the projectile knows that this block is not generic
isGeneric = false;

// Check if the door is unlocked already
alarm[0] = 1;