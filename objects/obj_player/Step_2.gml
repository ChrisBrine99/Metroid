// Always perform the object's inherited end step event, which handles state switching, but exit the function
// early if the game's state isn't currently set to its "normal" state, which pauses any updates to the existing
// jump effect instances and the arm cannon's visibility/offset.
event_inherited();
if (GAME_CURRENT_STATE != GSTATE_NORMAL) {return;}

// Loop through all existing jump effect structs to decrement their alpha levels by a pre-set amount; destroying
// that struct if its alpha level has reached or gone below a value of zero.
var _jumpEffect = jumpEffectID;
var _length = ds_list_size(jumpEffectID);
for (var i = 0; i < _length; i++){
	with(_jumpEffect[| i]){
		alpha -= 0.03 * DELTA_TIME;
		if (alpha <= 0.0){ // Removing the effect once its alpha goes below 0.
			delete _jumpEffect[| i];
			ds_list_delete(_jumpEffect, i);
			_length--; // Subtract one from "i" and the length to accommodate for the newly removed struct.
			i--;
		}
	}
}

// Finally, update the arm cannon's offset position and visibility depending on Samus's actions in the frame.
with(armCannon) {end_step();}