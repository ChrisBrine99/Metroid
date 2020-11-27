/// @description A simplified collision method for use by entities and other valid objects. It ignores slope
/// movement and just checks for a collision at any point with a block. For there, the object can be destroyed
/// if that flag is set.
/// @param destroyOnCollide

function entity_world_collision_simple(_destroyOnCollide){
	// Calculate the amount the entity should move relative to the current frame; store any fractional values.
	deltaHspd = hspd * global.deltaTime;
	deltaVspd = vspd * global.deltaTime;
	remove_movement_fractions();

	// Horizontal collision
	var _hspd = sign(hspd);
	if (place_meeting(x + deltaHspd, y, par_block)){
		// Move pixel-by-pixel until the wall is reached.
		while(!place_meeting(x + _hspd, y, par_block)){
			x += _hspd;
		}
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
		isDestroyed = _destroyOnCollide;
		deltaVspd = 0;
		vspd = 0;
	}
	y += deltaVspd;
}