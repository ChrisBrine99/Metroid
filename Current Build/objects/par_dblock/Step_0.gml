/// @description Handles what state the destructable block is currently in
// You can write your code in this editor

if (!beenHit){
	sprite_index = setSprite;
	mask_index = setMask;
}
else{
	sprite_index = -1;
	mask_index = -1;
	if (regenTimer > 0){
		// Create the block destruction effect
		if (regenTimer == maxRegenTimer){
			instance_create_depth(x, y, 100, obj_dblock_destroy);
		}
		// Countdown a timer until the block regenerates
		regenTimer--;
		if (regenTimer == 0){
			var obj;
			obj = instance_create_depth(x, y, 100, obj_dblock_regen);
			obj.forFx = false;
		}
	}
	else if (regenTimer == -1){
		instance_destroy(self);
	}
}

if (instance_exists(obj_bomb_explode)){ // Collision with a bomb explosion
	var bomb = instance_nearest(x, y, obj_bomb_explode);
	if (setObject == -1 || setObject == 0){
		if (place_meeting(x, y, bomb)){
			beenHit = true;
		}
	}
	// Make the block not hidden
	if (hidden){
		if (place_meeting(x, y, bomb)){
			hidden = false;
		}	
	}
}
if (instance_exists(obj_pBomb_explode)){ // Collision with a power bomb explosion
	var pBomb = instance_nearest(x, y, obj_pBomb_explode);
	if (setObject == -1 || setObject == 3){
		if (place_meeting(x, y, pBomb)){
			beenHit = true;
		}
	}
}