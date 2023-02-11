// 
var _jumpEffect = jumpEffectID;
var _length = ds_list_size(jumpEffectID);
for (var i = 0; i < _length; i++){
	with(_jumpEffect[| i]){
		alpha -= 0.03 * DELTA_TIME;
		if (alpha <= 0){ // Removing the effect once its alpha goes below 0.
			delete _jumpEffect[| i];
			ds_list_delete(_jumpEffect, i);
		}
	}
}

// 
with(armCannon) {end_step();}
event_inherited();