/// @description Handling Collision with Destructibles

// Call the parent's step event before handling collision
event_inherited();

// Ignore any collisions the flag is toggled
if (ignoreCollision){
	return;
}

// Handling the collision with walls in two varying ways: colliding with a single block and getting destroyed 
// OR going through all objects, but destroying those that are affected by the projectile.
if (destroyOnWallCollide){
	var _id = entity_world_collision_simple(true);
	with(_id){ // Executes only if a valid ID is returned
		if (!ignoreCollision){
			var _isAffected = (ds_list_find_index(projectileWeakness, Weapon.All) != -1 || ds_list_find_index(projectileWeakness, other.projectileType) != -1);
			isInactive = _isAffected;
		}
	}
} else{ // The projectile can go through the wall (Wave Beam, Spazer Beam, Plasma Beam)
	var _blocks, _length;
	_blocks = entity_world_collision_passthrough();
	_length = ds_list_size(_blocks);
	for (var i = 0; i < _length; i++){
		with(_blocks[| i]){ // Loop through all blocks that were collided with and check if they've been destroyed
			if (!ignoreCollision){
				var _isAffected = (ds_list_find_index(projectileWeakness, Weapon.All) != -1 || ds_list_find_index(projectileWeakness, other.projectileType) != -1);
				isInactive = _isAffected;
			}
		}
	}
	ds_list_destroy(_blocks);
}