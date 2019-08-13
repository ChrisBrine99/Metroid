/// @description Insert description here
// You can write your code in this editor

// The door's classification which will determine what can open it
doorType = DOOR_TYPE.NORMAL;

// Freeze the animation so it doesn't get destroyed instantly
imgSpd = 0;				// Determines the speed that the image animates at
imgIndex = 0;			// The current frame of a sprite that is being displayed

// If true, the door will be closing behind Samus
open = false;
// Check if the door needs to be opened
if (distance_to_object(obj_player) <= 16){
	image_index = 2;
	open = true;
}
unlocked = false;		// If true, the door will be opening from projectile/bomb collision
soundHasPlayed = false; // If true, the sound of the door opening/closing will no longer play
index = -1;				// The index the door will set to true when opened by the player

// Make sure the projectile knows that this block is not generic
isGeneric = false;

// Check if the door is unlocked already
alarm[0] = 1;