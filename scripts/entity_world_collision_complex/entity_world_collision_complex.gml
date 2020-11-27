/// @description Updates positions and checks for any collisions at said position. If there is a collision, 
/// movement is pixel-by-pixel until there is no space between the wall and entity.
/// @param destroyOnCollide

function entity_world_collision_complex(_destroyOnCollide) {
	// Calculate the amount the entity should move relative to the current frame; store any fractional values.
	deltaHspd = hspd * global.deltaTime;
	deltaVspd = vspd * global.deltaTime;
	remove_movement_fractions();

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