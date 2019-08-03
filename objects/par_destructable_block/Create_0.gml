/// @description Determine what object this block is destroyed by.
// You can write your code in this editor

// Let collision know that this isn't a generic block
isGeneric = false;

// Variables that keep track of the block's current state
isDestroyed = false;				// If true, the block will be destroy either temporarily or until the user exits the room.
destroyTimer = 0;					// The time in frames before the block will regenerate.
destroyTimerMax = 0;				// The maximum number of frames a block will be destroyed for.
checkForCollision = true;			// If false, any collision checks will not execute.
blockType = DYNAMIC_BLOCK.NORMAL;	// Determines what objects destroy this block.
hidden = false;						// If true, the block will be hidden by a tile.
tileMap = noone;					// Holds the tileMap on the layer that the hidden block will draw to.
tileData = noone;					// Holds the tile that will be drawn on top of the hidden block.

// Check if the block should be hidden
alarm[0] = 1;