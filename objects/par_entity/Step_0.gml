/// @description Calling Current State Function/Executing General Code

// Counting down the entity's hitTimer if it had been by a hostile entity/projectile.
if (isHit){
	recoveryTimer -= global.deltaTime;
	if (recoveryTimer <= 0){
		if (!place_meeting(x, y, lastHitProjectile)){
			lastHitProjectile = noone;
		}
		isHit = false;
	}
}

// Regenerating hitpoints based on a ratio of amount regenerated divided by the time in seconds
// that the hitpoints regenerates said amount. Allows for any speed of hitpoint regeneration.
if (hpRegenAmount > 0 && regenSpeed > 0 && hitpoints < maxHitpoints){
	hpRegenFraction += ((hpRegenAmount / regenSpeed) * global.deltaTime) / 60;
	if (hpRegenFraction >= 1){
		var _healthGained = floor(hpRegenFraction);
		update_hitpoints(_healthGained);
		hpRegenFraction -= _healthGained;
	}
}

// Execute the method containing the current state's code.
script_execute(curState);