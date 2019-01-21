/// @description Destroys the instance
// You can write your code in this editor

var enemy, block;
enemy = noone;
if (instance_exists(par_enemy))
	enemy = instance_nearest(x, y, par_enemy);
if (!place_meeting(x, y, obj_samus) && !place_meeting(x, y, enemy)){
	//Setting the block back to solid
	block = instance_nearest(x, y, par_dblock);
	if (place_meeting(x, y, block)){
	    with(block){
	        beenHit = false;
			regenTimer = maxRegenTimer;
	    }
	}
}
else{
    //Restarting the timer so Samus doesn't get stuck in the block
    with(instance_nearest(x,y,par_block)){
        regenTimer = maxRegenTimer;
    }
    instance_create_depth(x, y, 50, obj_dblock_destroy);
}
instance_destroy(self);