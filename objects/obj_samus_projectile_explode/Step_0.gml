/// @description Handling Collision with Destructibles

// Call the parent's step event before handling collision
event_inherited();

// Bypasses the collision check for explosions that are merely just visual effects
if (ignoreCollision){
	return;
}

// Handling collision between an explosion and all destructible blocks it has come into contact with during 
// the current frame.
var _list = ds_list_create();
instance_place_list(x, y, par_block, _list, false);

var _length = ds_list_size(_list);
for (var i = 0; i < _length; i++){
	with(_list[| i]){  // Loop through all blocks that were collided with and check if they've been destroyed
		if (!ignoreCollision){
			var _isAffected = (ds_list_find_index(projectileWeakness, Weapon.All) != -1 || ds_list_find_index(projectileWeakness, other.projectileType) != -1);
			isInactive = _isAffected;
		}
	}
}

ds_list_destroy(_list);