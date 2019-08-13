/// @description Initializing Variables
// You can write your code in this editor

blockToDestroy = DYNAMIC_BLOCK.NORMAL;
setExplodeFX = noone;

explodeTime = 60;
imgSpd = 1;

// Creating the ambient light source
ambLight = instance_create_depth(x, y, 15, obj_light_emitter);

// Enable this object to use the animation scripts
scr_animation_create();