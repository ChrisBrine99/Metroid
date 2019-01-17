/// @description Randomly spawns in an item drop by generating a random number between 0 and 99.
/// Can spawn in a small health drop, large health drop, missile drop, super missile drop
/// or a power bomb drop. 
/// Note: If the player is full on missiles and the chance causes a missile to spawn; it
/// will instead spawn in a small/large health pickup instead. The same principle applies to
/// all the other ammo pickups as well.

var chance, pickup;
chance = random(100);
randomize();

if (chance >= 0 && chance < 20){ // 20% chance to drop a small health pickup
	instance_create_depth(x, y + (sprite_height / 2), depth, obj_small_health_pickup);
}
else if (chance >= 20 && chance < 30){ // 10% chance to drop a large health pickup
	instance_create_depth(x, y + (sprite_height / 2), depth, obj_large_health_pickup);
}
else if (chance >= 30 && chance < 50){ // 20% chance to drop a missile pickup
	if (global.missilesMax > 0 && global.missiles < global.missilesMax){
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_missile_pickup);
	}
	else{ // Spawn a small health pickup if the player doesn't have missiles or they have a full capacity
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_small_health_pickup);
	}
}
else if (chance >= 50 && chance < 55){ // 5% chance to drop a super missile pickup
	if (global.sMissilesMax > 0 && global.sMissiles < global.sMissilesMax){
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_sMissile_pickup);
	}
	else{ // Spawn a small health pickup if the player doesn't have super missiles or they have a full capacity
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_small_health_pickup);
	}	
}
else if (chance >= 55 && chance < 60){ // 5% chance to drop a power bomb pickup
	if (global.pBombsMax > 0 && global.pBombs < global.pBombsMax){
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_pBomb_pickup);
	}
	else{ // Spawn a large health pickup if the player doesn't have super missiles or they have a full capacity
		instance_create_depth(x, y + (sprite_height / 2), depth, obj_large_health_pickup);
	}		
}