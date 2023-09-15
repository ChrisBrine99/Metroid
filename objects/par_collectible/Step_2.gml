// Updating the light source's properties (IF A LIGHT SOURCE EXISTS FOR THE GIVEN COLLECTIBLE) so it gets dimmer 
// and brighter at the same rate as the collectible animates between its dim and bright images, respectively.
if (lightComponent != noone){
	var _imageIndex = floor(imageIndex);
	var _baseRadius = baseRadius;
	var _baseStrength = baseStrength;
	with(lightComponent){
		if (_imageIndex == 1) {set_properties(_baseRadius, color, _baseStrength);}
		else {set_properties(round(_baseRadius * 1.3), color, _baseStrength * 1.3);}
	}
}

// Don't continue onto the code below if there's no collectible ball/destructible collider object obscuring
// the collectible in question. If that is the case, the code will continue as normal.
if (destructibleID == noone) 
	return;

// Determine the visibilty of the collectible itself and the light it produces based on if the dectructible
// object that exists on top of the collectible has been destroyed by the player or not yet. If the block is
// solid, hide the collectible; if not, allow it to produce light and show up on screen to see.
var _stateFlags = stateFlags;
with(destructibleID){
	if (ENTT_IS_DESTROYED){
		if (timeToRespawn == DEST_RESPAWN_INFINITE) 
			other.destructibleID = noone;
		// Activate the light produced by the collectible and allow it to render itself once again.
		if (_stateFlags & DEST_HIDDEN != 0){
			with(other.lightComponent) 
				isActive = true;
			_stateFlags &= ~DEST_HIDDEN;
		}
	} else{ // Hide the collectible and its light source.
		with(other.lightComponent) 
			isActive = false;
		_stateFlags |= DEST_HIDDEN;
	}
}
stateFlags = _stateFlags;