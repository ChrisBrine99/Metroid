// Once the animation has finished itself, the ANIMATION_END flag will be set to true; causing the door to be
// destroyed since it doesn't close itself again until the room is re-entered.
if (imageIndex == spriteLength - 1 && animSpeed > 0.0){
	if (ENTT_CAN_DRAW_SELF){
		stateFlags &= ~ENTT_DRAW_SELF;
		mask_index = spr_empty_mask;
		lightComponent.isActive = false;
	}
	return;
}

// Smoothly fades the door's ambient light source out of visibilty alongisde its animation.
if (animSpeed != 0.0){
	lightComponent.strength = LGHT_ACTIVE_STRENGTH - 
			((imageIndex / spriteLength) * LGHT_ACTIVE_STRENGTH);
}

// Play the door's opening sound if it has been set to open. Then, flip the "opened" flag back to zero to 
// prevent the sound from playing on every subsequent frame. The event exits early since the door can't both 
// open and close at the same time, so the rest of the code would be pointless to execute.
if (DOOR_IS_OPENED){
	audioComponent.play_sound(snd_door_open, SND_TYPE_GENERAL, false, true, DOOR_VOLUME);
	stateFlags &= ~DOOR_OPENED;
	return;
}

// Play the door's closing sound if it hasn't played already AND the door has been set to close.
if (DOOR_IS_CLOSING && !ENTT_IS_ANIM_PAUSED){
	audioComponent.play_sound(snd_door_close, SND_TYPE_GENERAL, false, true, DOOR_VOLUME);
	stateFlags &= ~DOOR_CLOSING;
}