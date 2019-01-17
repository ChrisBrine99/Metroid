///scr_projectile_destroy()
// The destroy event for any and all player made projectiles.

var explodeObj = argument0;
if (canExplode){
	var obj = instance_create_depth(x, y, 50, explodeObj);	
	obj.setIndex = setIndex;
}

// Check if the beam is colliding with a destructable block
scr_dblock_collision();