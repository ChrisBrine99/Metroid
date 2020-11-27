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