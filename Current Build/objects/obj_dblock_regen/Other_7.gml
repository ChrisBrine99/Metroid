/// @description Destroys the instance
// You can write your code in this editor

if (!place_meeting(x,y,obj_samus)){
	//Setting the block back to solid
    with(instance_nearest(x,y,par_dblock)){
        beenHit = false;
		regenTimer = maxRegenTimer;
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