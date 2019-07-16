/// @description Insert description here
// You can write your code in this editor

// Call the parent's create event
event_inherited();

// Set the explosion effect
setExplodeFX = obj_bomb_explode;

// Set the blocks that the bomb can destroy
blockToDestroy = DYNAMIC_BLOCK.BOMB;

// Editing the ambient light source's characteristics
ambLight.xRad = 20;
ambLight.yRad = 20;
ambLight.lightCol = c_aqua;