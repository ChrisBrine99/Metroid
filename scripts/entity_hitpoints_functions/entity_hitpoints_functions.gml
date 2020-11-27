/// @description These functions relate to an entity's hitpoints; updating that current hitpoint amount, increasing
/// their current maximum hitpoints, and updating their hitpoint regeneration ratio, which is a sum of all the
/// hitpoints regen ratios applied at once.

/// @description Updates the current hitpoints with an increase or decrease to the value. Limits the value of 
/// the hitpoints to be within the range of 0 and the maximum hitpoints; with a value of 0 destroying the entity 
/// if it isn't set to invincible.
/// @param modifier
function update_hitpoints(_modifier){
	hitpoints += _modifier;
	if (hitpoints > maxHitpoints){
		hitpoints = maxHitpoints;
	} else if (hitpoints <= 0 && !isInvincible){
		hitpoints = 0;
		isDestroyed = true;
	}
}

/// @description Adds/subtracts a determines health regeneration ratio from the current hp regen amount and 
/// speed of that regeneration. This allows for stacking of regeneration effects.
/// @param hpGained
/// @param interval
function update_hitpoint_regen_ratio(_hpGained, _interval){
	if (regenSpeed != 0){ // Calculate an updated ratio for the health regen based on the addition of the two ratios.
		var _factor = _interval / regenSpeed;
		hpRegenAmount = max(0, (hpRegenAmount * _factor) + _hpGained);
		regenSpeed = (hpRegenAmount == 0) ? 0 : (regenSpeed * _factor);
	} else{ // Set the intiial hitpoints regeneration ratio if no regeneration is currently present
		hpRegenAmount = _hpGained;
		regenSpeed = _interval;
	}
}

/// @description Sets the entity's maximum hitpoints to a spefcified value. Optionally, the hitpoints can be set
/// to the maximum value. However, if hitpoints are greater than the maximum after the change, they will be set
/// to that maximum value. Setting relative will increase or decrease the current maximum by the specified value. 
/// @param maxHitpoints
/// @param restoreHealth
/// @param relative
function set_max_hitpoints(_maxHitpoints, _restoreHealth, _relative) {
	maxHitpoints = _relative ? maxHitpoints + _maxHitpoints : _maxHitpoints;
	if (_restoreHealth || hitpoints > maxHitpoints){ // Optional health restore
		hitpoints = maxHitpoints;
	}
}