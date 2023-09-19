// Always perform the inherited logic within the end step event for "par_dynamic_entity" and that same event
// for the arm cannon struct.
event_inherited();
with(armCannon) {end_step();}

// Don't update any visible ghost effect structs or allow Samus's aeion energy to recharge if the game isn't
// currently within its standard state.
if (GAME_CURRENT_STATE != GSTATE_NORMAL) 
	return;

// Update all active ghost effect structs, which is as simple as decrementing their alpha levels until they
// go below a value of zero. At that point, the ghost effect object is disabled until re-enabled once again.
var _deltaTime = DELTA_TIME;
for (var i = 0; i < PLYR_NUM_GHOST_EFFECTS; i++){
	with(ghostEffectIDs[i]){
		if (!visible) {continue;}	// Unseen ghost effects are assumed to be inactive.
		
		alpha -= 0.03 * _deltaTime;
		if (alpha < 0.0){
			visible = false;
			alpha	= 0.0;
		}
	}
}

// Decrement the cooldown timer, which will begin filling the aeion gauge once the value goes below -60. After
// that, the aeion will slowly restore itself until the gauge is full again.
if (curAeion < maxAeion){
	aeionCooldownTimer -= _deltaTime;
	if (aeionCooldownTimer < -60.0){
		aeionFillTimer += 0.3 * _deltaTime;
		if (aeionFillTimer >= 1.0){
			aeionFillTimer -= 1.0;
			curAeion++;
		}
		aeionCooldownTimer = -60.0;
	}
}