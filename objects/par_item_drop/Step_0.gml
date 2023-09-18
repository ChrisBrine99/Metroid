// The life timer (As well as the sprite flicker) is paused whenever the game state isn't set to "Normal".
if (ENTT_IS_DESTROYED || !ENTT_IS_ACTIVE) {return;}

hitpoints -= DELTA_TIME; // Countdown timer until destruction of the pickup.
if (hitpoints <= 0.0){
	stateFlags |= ENTT_DESTROYED;
} else if (hitpoints < maxHitpoints){ // NOTE: "maxHitpoints" is 25% of starting lifetime value.
	flickerTimer += DELTA_TIME;
	if (flickerTimer > 1.0){ // Apply flicker at a constant rate.
		flickerTimer = 0.0;
		if (ENTT_CAN_DRAW_SELF)	{stateFlags &= ~ENTT_DRAW_SELF;}
		else					{stateFlags |=  ENTT_DRAW_SELF;}
	}
}