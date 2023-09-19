// If the enemy was spawned from a spawner object, decrement the current number of instances that currently
// exist due to said spawner, and then spawn an item if the enemy is able to actually drop an item.
with(linkedSpawnerID) {curInstances--;}
if (!ENMY_CAN_DROP_ITEM) 
	return;

// Generate a floating point number between 0.0 and 1.0, which will represent a percentage value between 0 and 100,
// respectively. After that, check to see if the value generated is within the range to drop energy, aeion, ammunition,
// or nothing at all.
var _dropChance = random_range(0.0, 1.0);
if (_dropChance <= energyDropChance){
	var _hitpointRatio = 0.0;
	with(PLAYER) {_hitpointRatio = (hitpoints / maxHitpoints) * 0.25;}

	// Utilizing the player's hitpoint ratio, spawn a small or large energy drop based on the default small energy drop
	// percentage minus the hitpoint ratio's value. The chance of a large energy drop spawning can have its chance 
	// increased by around 25% max.
	var _energyDrop = random_range(0.0, 1.0);
	if (_energyDrop <= SM_ENERGY_DROP_CHANCE - _hitpointRatio)	{instance_create_object(x, y, obj_sm_energy_drop, depth - 1);}
	else														{instance_create_object(x, y, obj_lg_energy_drop, depth - 1);}
} else if (_dropChance <= energyDropChance + aeionDropChance){
	if (PLAYER.maxAeion > 0){ // Aeion powers unlocked; spawn aeion orb.
		instance_create_object(x, y, obj_aeion_drop, depth - 1);
	} else{ // 80/20 chance to drop small energy orb vs. large orb.
		if (!irandom(5))	{instance_create_object(x, y, obj_lg_energy_drop, depth - 1);}
		else				{instance_create_object(x, y, obj_sm_energy_drop, depth - 1);}
	}
} else if (_dropChance <= (energyDropChance + aeionDropChance) + ammoDropChance){
	var _ammoDrop = random_range(0.0, 1.0); // Roll chance for dropping missile ammo or power bomb ammo.
	if (event_get_flag(FLAG_MISSILES) && _ammoDrop <= MISSILE_DROP_CHANCE){ // Missiles unlocked; drop ammo for it.
		instance_create_object(x, y, obj_missile_drop, depth - 1);
	} else if (event_get_flag(FLAG_POWER_BOMBS)){ // Power bombs unlocked; drop ammo is missiles aren't dropped.
		
	} else{ // 80/20 chance to drop small energy orb vs. large energy orb.
		if (!irandom(5))	{instance_create_object(x, y, obj_lg_energy_drop, depth - 1);}
		else				{instance_create_object(x, y, obj_sm_energy_drop, depth - 1);}
	}
}