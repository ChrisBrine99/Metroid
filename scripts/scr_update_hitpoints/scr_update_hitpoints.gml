/// @Description Updates the health and lives of an entity. Returns the new hitpoint and lives values to overwrite the 
/// previous hitpointand lives values with. Will prevent both from exceeding their maximum and mimimmum limits as well.
/// @param amount

var amount;
amount = argument0;

// Calculate the entity's new health value
curHitpoints += amount;

// Check if the newly updated health goes below 0 or above the entity's maximum health
if (curHitpoints > maxHitpoints){
	// If the entity still has room for more lives
	if (curLives < maxLives){
		curHitpoints -= maxHitpoints;
		curLives++;
	} else{ // The entity is at maximum health
		curHitpoints = maxHitpoints;
		curLives = maxLives;
	}
} else if (curHitpoints < 0){
	// Subtract a life if the entity has one to spare
	if (curLives > 0){
		curHitpoints += maxHitpoints;
		curLives--;
	} else{ // The entity has died
		curHitpoints = 0;
		curLives = 0;
	}
}