/// @description Handles collision between a par_entity child object and any par_projectile child object.

function entity_projectile_collision(){
	var _entities, _projectileType, _damage, _id;
	_entities = ds_list_create();
	_projectileType = projectileType;
	_damage = -damage;
	_id = id;

	// Gather a list of all entities that the projectile will collide with between its current and next position.
	collision_line_list(x, y, x + deltaHspd, y + deltaVspd, par_entity, false, true, _entities, false);

	// Loop through all entities that were hit in that frame, and evaluate their collision with the projectile.
	var _length = ds_list_size(_entities);
	for (var i = 0; i < _length; i++){
		with(_entities[| i]){
			if (isInvincible || ds_list_find_index(projectileWeakness, _projectileType) == -1){
				continue; // Move onto the next entity
			}
			// If the projectile hurts the entity AND the entity hasn't been hit by this projectile, deal damage
			// equal to the damage the projectile deals times the damage resistance of the entity. This means the
			// lower the value for the damage resistance, the less damage the entity will take.
			if (lastHitProjectile != _id && !isHit){
				if (script_exists(hitScript)){ // An optional script the entity can execute when hit
					script_execute(hitScript);
				}
				update_hitpoints(floor(_damage * damageResistance));
				timeToRecover = recoveryTimer;
				lastHitProjectile = _id;
				isHit = true;
			}
		}
	}
	// If an entity was hit in this frame, delete the projectile if it is destroyed upon collision with entities.
	if (_length > 0){
		isDestroyed = destroyOnEntityCollide;
	}
	ds_list_destroy(_entities);
}