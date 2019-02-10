///scr_dblock_collision()
// Collision handling for projectiles and destructable objects.

if (instance_exists(par_dblock)){
	var block = instance_place(x + hspd, y + vspd, par_dblock);
	// Check for collision with destructable blocks
	if (place_meeting(x + hspd, y + vspd, block)){
		if (block.setObject == 5 || block.setObject == -1 || (block.objName == "obj_missiles_dblock" && object_get_name(object_index) == "obj_missile")){ // Regular destructble blocks
			if (setIndex < 2) instance_destroy(self);
			block.beenHit = true;
		}
		// Make the block not hidden
		if (block.hidden){
			block.hidden = false;
		}
	}
}