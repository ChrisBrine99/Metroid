/// @description Contains collision functions that are used by both children of par_entity, and children of
/// par_entity_projectile. However, the complex collision should only be used by entities that can traverse
/// slopes (Ex. Samus, and certain AI)

/// @description A simplified collision method for use by entities and other valid objects. It ignores slope
/// movement and just checks for a collision at any point with a block. For there, the object can be destroyed
/// if that flag is set.
/// @param destroyOnCollide
function entity_world_collision_simple(_destroyOnCollide){
	var _collidedID = noone;
	
	// Horizontal collision
	var _hspd = sign(hspd);
	if (place_meeting(x + deltaHspd, y, par_block)){
		// Move pixel-by-pixel until the wall is reached.
		while(!place_meeting(x + _hspd, y, par_block)){
			x += _hspd;
		}
		_collidedID = instance_place(x + _hspd, y, par_block);
		isDestroyed = _destroyOnCollide;
		deltaHspd = 0;
		hspd = 0;
	}
	x += deltaHspd;

	// Vertical collision
	var _vspd = sign(vspd);
	if (place_meeting(x, y + deltaVspd, par_block)){
		// Move pixel-by-pixel until the wall is reached.
		while(!place_meeting(x, y + _vspd, par_block)){
			y += _vspd;
		}
		_collidedID = instance_place(x, y + _vspd, par_block);
		isDestroyed = _destroyOnCollide;
		deltaVspd = 0;
		vspd = 0;
	}
	y += deltaVspd;
	
	return _collidedID;
}

/// @description Updates positions and checks for any collisions at said position. If there is a collision, 
/// movement is pixel-by-pixel until there is no space between the wall and entity.
/// @param destroyOnCollide
function entity_world_collision_complex(_destroyOnCollide) {
	// Horizontal collision
	var _hspd = sign(hspd);
	if (place_meeting(x + deltaHspd, y, par_block)){
		// Go pixel-by-pixel relative to the entity's maximum hspd to calculate how fast they need to move 
		// up the slope.
		var _yPlus = 0;
		while(place_meeting(x + deltaHspd, y - _yPlus, par_block) && _yPlus <= floor(maxHspd)){
			_yPlus += 1;
		}
		// Standard horizontal collision will occur if there is a collision where _yPlus is trying to take 
		// the entity.
		if (place_meeting(x + deltaHspd, y - _yPlus, par_block)){
			// Move pixel-by-pixel until the wall is reached.
			while(!place_meeting(x + _hspd, y, par_block)){
				x += _hspd;
			}
			isDestroyed = _destroyOnCollide;
			deltaHspd = 0;
			hspd = 0;
		} else{ // Moving up a slope
			y -= _yPlus;
		}
	} else if (isGrounded){ // Moving down a slope
		// Go pixel-by-pixel relative to the entity's maximum hspd to lock the entity onto the slope, but ONLY
		// whenever the entity is on the ground.
		var _yMinus = 0;
		while(!place_meeting(x + deltaHspd, y + 1, par_block) && _yMinus <= floor(maxHspd)){
			_yMinus++;
		}
		// Make sure the entity is on solid ground before moving them down by the amount needed
		if (place_meeting(x, y + 1, par_block)){
			y += _yMinus;
		}
	}
	x += deltaHspd;

	// Vertical collision
	var _vspd = sign(vspd);
	if (place_meeting(x, y + deltaVspd, par_block)){
		// Move pixel-by-pixel until the wall is reached.
		while(!place_meeting(x, y + _vspd, par_block)){
			y += _vspd;
		}
		isDestroyed = _destroyOnCollide;
		deltaVspd = 0;
		vspd = 0;
	}
	y += deltaVspd;
}

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
				with(other){ // Destroy the projectile if necessary
					isDestroyed = destroyOnEntityCollide;
					if (isDestroyed){
						break; // If the projectile has been destroyed, ignore all other potential collisions
					}
				}
			}
		}
	}
	// Remove the list from memory to avoid potential memory leaks.
	ds_list_destroy(_entities);
}