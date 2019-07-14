/// @description Determine what object this block is destroyed by.
// You can write your code in this editor

// Let collision know that this isn't a generic block
isGeneric = false;

// The default for the setObject variable
setObject[0] = noone;
if (blockType == DYNAMIC_BLOCK.NORMAL){ // Destroyed by everything
	setObject[0] = par_projectile;
	setObject[1] = obj_bomb_explode;
	//setObject[2] = obj_pBomb_explode;
} else if (blockType == DYNAMIC_BLOCK.MISSILE){ // Destroyed by the missile and super missile
	setObject[0] = obj_missile;
	setObject[1] = obj_sMissile;
} else if (blockType == DYNAMIC_BLOCK.SUPER_MISSILE){ // Destroyed by super missiles
	setObject[0] = obj_sMissile;
} else if (blockType == DYNAMIC_BLOCK.BOMB){ // Destroyed by bombs and power bombs
	setObject[0] = obj_bomb_explode;
	//setObject[1] = obj_pBomb_explode;
}
entityNum = array_length_1d(setObject);

// Variables that keep track of the block's current state
isDestroyed = false;
destroyTimer = 0;
checkForCollision = true;
// Unseen:		destroyTimerMax		-- The maximum number of frames a block will be destroyed for.
//				blockType			-- Determines what objects destroy this block.
//				hidden				-- If true, the block will be disguised as a regular tile.
//				hiddenImg			-- The index of the block's hidden sprite.