/// @description Handling Collision with Destructibles

// Call the parent's step event before handling collision
event_inherited();

// Finally, handle the projectile's collision with the world. All projectiles have collision, so it isn't
// state-based like a normal entity.
var _id = entity_world_collision_simple(destroyOnWallCollide);
with(_id){ // Executes only if a valid ID is returned
	if (object_is_ancestor(_id.object_index, par_block) && ds_list_find_index(projectileWeakness, other.projectileType) != -1){
		mask_index = spr_empty;
	}
}