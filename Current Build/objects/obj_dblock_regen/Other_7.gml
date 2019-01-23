/// @description Destroys the instance
// You can write your code in this editor

if (forFx){
	instance_destroy(self);
	return;
}

var block, enemy;
block = instance_nearest(x, y, par_dblock);
enemy = noone;
if (instance_exists(par_enemy))
	enemy = instance_nearest(x, y, par_enemy);
if (!place_meeting(x, y, obj_samus) && !place_meeting(x, y, enemy)){
	//Setting the block back to solid
	with(block){
		beenHit = false;
		regenTimer = maxRegenTimer;
	}
}
else{
    //Restarting the timer so Samus doesn't get stuck in the block
    with(block){
        regenTimer = maxRegenTimer;
    }
    instance_create_depth(x, y, 100, obj_dblock_destroy);
}
instance_destroy(self);