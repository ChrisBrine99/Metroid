/// @description These functions are helper functions for both par_entity and par_entity_projectile, respectively.
/// They include updating the current state of the object, (NOTE -- this state updating function can be used by
/// ANY object that has both the curState and lastState variables) updating the current sprite used by the entity,
/// and light creation for the entity, which is always a circular light source.

/// @description Removes and stores away the decimal values for the entity's current hspd and vspd. This ensures 
/// that the entity will never move on a sub-pixel basis, which makes collision a lot more simplified.
function remove_movement_fractions(){
	// Calculate the amount the entity should move relative to the current frame; store any fractional values.
	deltaHspd = hspd * global.deltaTime;
	deltaVspd = vspd * global.deltaTime;
	
	if (hspd == 0){
		hspdFraction = 0;
	}
	// Recalculate the remaining fractional value for horizontal movement
	deltaHspd += hspdFraction;
	hspdFraction = deltaHspd - (floor(abs(deltaHspd)) * sign(deltaHspd));
	deltaHspd -= hspdFraction;

	if (vspd == 0){
		vspdFraction = 0;
	}
	// Recalculate the remaining fractional value for vertical movement
	deltaVspd += vspdFraction;
	vspdFraction = deltaVspd - (floor(abs(deltaVspd)) * sign(deltaVspd));
	deltaVspd -= vspdFraction;
}

/// @description Updates an entity's current sprite and the data that is used relative to that sprite; the loop
/// offset index for the sprite, the number of images in the sprite, and the speed of the sprite's animation.
/// @param spriteIndex
/// @param resetImageIndex
/// @param *transitionSprite
/// @param *transitionSpeed
function sprite_update(_spriteIndex, _resetImageIndex, _transitionSprite, _transitionSpeed) {
	// A sprite transition is occuring; ignore any sprite changes until that has finished. Also, ignore updating the
	// sprite if the same sprite is being set.
	if (sprite_index == transitionSprite || spriteIndex == _spriteIndex){
		return;
	}

	// Set all sprite-related variables to the new sprite's information
	spriteIndex = _spriteIndex;
	spriteNumber = sprite_get_number(_spriteIndex);
	spriteSpeed = sprite_get_speed(_spriteIndex);
	curFrame = _resetImageIndex ? 0 : curFrame;
	// Optional arguments for a sprite transition between two different images. Allows for smoother looking 
	// changes in certain sprites. (Ex. entering/exiting morphball)
	transitionSprite = !argument_count >= 3 && sprite_exists(_transitionSprite) ? _transitionSprite : -1;
	transitionSpeed = !argument_count >= 4 ? _transitionSpeed : 0;
	transitionNumber = transitionSprite != -1 ? sprite_get_number(transitionSprite) : 0;
}

/// @description Sets the currently executed state to a new function index. Also stores the last state within 
/// its own variable for easy referece and comparison. If the passed in function is identical to the current 
/// state, don't change the state.
/// @param newState
function set_cur_state(_newState){
	if (_newState != curState){
		lastState = curState;
		curState = _newState;
	}
}

/// @description Creates a circular light for the entity's ambLight variable. From there, the size, color, 
/// strength, and offset position are all applied to said light.
/// @param offsetX
/// @param offsetY
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color
function entity_create_light(_offsetX, _offsetY, _radiusX, _radiusY, _strength, _color) {
	ambLight = instance_create_depth(x + _offsetX, y + _offsetY, ENTITY_DEPTH, obj_light);
	with(ambLight){ // Apply all the entity's settings to the light itself
		light_create_circle(_radiusX, _radiusY, _strength, _color);
	}
	lightPosition = [_offsetX, _offsetY];
}