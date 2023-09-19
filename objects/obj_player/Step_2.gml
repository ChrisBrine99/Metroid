// Always perform the object's inherited end step event, which handles state switching, but exit the function
// early if the game's state isn't currently set to its "normal" state, which pauses any updates to the existing
// jump effect instances and the arm cannon's visibility/offset.
event_inherited();

// 
with(armCannon) {end_step();}

// 
if (GAME_CURRENT_STATE != GSTATE_NORMAL) 
	return;

// 
var _deltaTime = DELTA_TIME;
for (var i = 0; i < PLYR_NUM_GHOST_EFFECTS; i++){
	with(ghostEffectIDs[i]){
		if (!visible) {continue;}
		
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