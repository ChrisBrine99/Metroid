// The life timer (As well as the sprite flicker) is paused whenever the game state isn't set to "Normal".
if (IS_DESTROYED || !IS_ACTIVE) {return;}

hitpoints -= DELTA_TIME; // Countdown timer until destruction of the pickup.
if (hitpoints <= 0.0){
	stateFlags |= (1 << DESTROYED);
} else if (hitpoints < maxHitpoints){ // NOTE: "maxHitpoints" is 25% of starting lifetime value.
	if (CAN_DRAW_SPRITE)	{stateFlags &= ~(1 << DRAW_SPRITE);}
	else					{stateFlags |= (1 << DRAW_SPRITE);}
}