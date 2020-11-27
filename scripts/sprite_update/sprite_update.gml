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
	transitionSprite = !is_undefined(_transitionSprite) && sprite_exists(_transitionSprite) ? _transitionSprite : -1;
	transitionSpeed = !is_undefined(_transitionSpeed) ? _transitionSpeed : 0;
	transitionNumber = transitionSprite != -1 ? sprite_get_number(transitionSprite) : 0;
}