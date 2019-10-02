/// @description Initializing Variables
// You can write your code in this editor

// The type of collider this object is
colliderType = COLLIDER.WARP;

isWarping = false;		// When true, the warp will initiate the transition between two rooms
fadeID = noone;			// Holds the instance ID for the warp's fade object when going between rooms

targetX	= 0;			// The X posiiton that Samus will appear at in the next room.
targetY	= 0;			// The Y position that Samus will appear at in the next room.
targetRoom = noone;		// The Room that Samus will be warping to.
mapMoveX = 0;			// How many cells to move the map in the x-position
mapMoveY = 0;			// How many cells to move the map in the y-position