// Always perform the object's inherited end step event, which handles state switching, but exit the function
// early if the game's state isn't currently set to its "normal" state, which pauses any updates to the existing
// jump effect instances and the arm cannon's visibility/offset.
event_inherited();
if (GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}

// Loop through all existing ghost effect structs to decrement their alpha levels by a pre-set amount; destroying
// that struct if its alpha level has reached or gone below a value of zero.
var _ghostEffect = ghostEffectID;
var _length = ds_list_size(ghostEffectID);
for (var i = 0; i < _length; i++){
	with(_ghostEffect[| i]){
		alpha -= 0.03 * DELTA_TIME;
		if (alpha <= 0.0){ // Removing the effect once its alpha goes below 0.
			delete _ghostEffect[| i];
			ds_list_delete(_ghostEffect, i);
			_length--; // Subtract one from "i" and the length to accommodate for the newly removed struct.
			i--;
		}
	}
}

// 
aeionCooldownTimer -= DELTA_TIME;
if (aeionCooldownTimer < -60.0 && curAeion < maxAeion){
	aeionFillTimer += DELTA_TIME * 0.4;
	if (aeionFillTimer >= 1.0){
		aeionFillTimer -= 1.0;
		curAeion++;
	}
	aeionCooldownTimer = -60.0;
}

// Finally, update the arm cannon's offset position and visibility depending on Samus's actions in the frame.
with(armCannon) {end_step();}