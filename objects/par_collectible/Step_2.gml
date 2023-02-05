// Updating the light source's properties (IF A LIGHT SOUCE EXISTS FOR THE GIVEN COLLECTIBLE) so it gets dimmer 
// and brighter at the same rate as the collectible animates between its dim and bright images, respectively.
if (lightComponent != noone){
	var _imageIndex = floor(imageIndex);
	var _baseRadius = baseRadius;
	var _baseStrength = baseStrength;
	with(lightComponent){
		if (_imageIndex == 1) {set_properties(_baseRadius, color, _baseStrength);} 
		else {set_properties(round(_baseRadius * 1.2), color, _baseStrength * 1.2);}
	}
}

// Don't continue onto the code below if there's no collectible ball/destructible collider object obscuring
// the collectible in question. If that is the case, the code will continue as normal.
if (destructibleID == noone) {return;}

// Determine the visibilty of the collectible itself and the light it produces based on if the dectructible
// object that exists on top of the collectible has been destroyed by the player or not yet. If the block is
// solid, hide the collectible; if not, allow it to produce light and show up on screen to see.
var _stateFlags = stateFlags;
with(destructibleID){
	if (IS_DESTROYED){
		if (timeToRespawn == RESPAWN_TIMER_INFINITE){
			with(other.lightComponent) {isActive = true;}
			other.destructibleID = noone;
		}
		_stateFlags &= ~(1 << HIDDEN);
	} else if (_stateFlags & (1 << HIDDEN)){
		with(other.lightComponent) {isActive = false;}
		_stateFlags |= (1 << HIDDEN);
	}
}
stateFlags = _stateFlags;