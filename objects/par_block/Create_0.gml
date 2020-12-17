/// @description Insert description here
// You can write your code in this editor

projectileWeakness = ds_list_create();

// A flag that determines if this block is checked when projectiles hit destructible objects
ignoreCollision = false;

// Some variables relating to the function of destructible blocks. The first variable is a flag that determines
// whether of not the block is currently destroyed. Meanwhile, the second variable is how long the block will
// stay destroyed for (-1 means it is destroyed until the player leaves the room). And finally, the third variable
// keeps track of the time in frames until the block will regenerate if it has been set to do so (60 = 1 second).
isInactive = false;
timeSpentInactive = -1;
inactiveTimer = 0;

// A flag that determines if a destructible object will create the block destruction effect. However, the block
// regeneration effect is required for now.
createDestroyEffect = true;