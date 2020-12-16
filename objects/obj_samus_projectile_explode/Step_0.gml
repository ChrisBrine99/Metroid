/// @description Handling Collision with Destructibles

// Call the parent's step event before handling collision
event_inherited();

var _list = ds_list_create();
instance_place_list(x, y, par_block, _list, false);

var _length = ds_list_size(_list);
for (var i = 0; i < _length; i++){
	with(_list[| i]){
		var _isAffected = (ds_list_find_index(projectileWeakness, Weapon.All) != -1 || ds_list_find_index(projectileWeakness, other.projectileType) != -1);
		isInactive = _isAffected;
	}
}

ds_list_destroy(_list);