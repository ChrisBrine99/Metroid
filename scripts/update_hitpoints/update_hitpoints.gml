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