// Once the animation has finished itself, the ANIMATION_END flag will be set to true; causing the door to be
// destroyed since it doesn't close itself again until the room is re-entered.
if (DID_ANIMATION_END){
	stateFlags &= ~(1 << DRAW_SPRITE);
	stateFlags |= (1 << DESTROYED);
	imageIndex = spriteLength - 1;
	animSpeed = 0;
	return;
}

// Smoothly fades the door's ambient light source out of visibilty alongisde its animation.
if (animSpeed > 0) {lightComponent.strength = 0.7 - ((imageIndex / spriteLength) * 0.7);}