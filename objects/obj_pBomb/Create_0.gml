/// @description Insert description here
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// Modify a few variables to fit the power bomb
explodeTime = 100;
//setExplodeFX = obj_pBomb_explode;

// Set the blocks that the power bomb can destroy
blockToDestroy = DYNAMIC_BLOCK.POWER_BOMB;

// Editing the ambient light source's characteristics
ambLight.xRad = 20;
ambLight.yRad = 20;
ambLight.lightCol = c_fuchsia;