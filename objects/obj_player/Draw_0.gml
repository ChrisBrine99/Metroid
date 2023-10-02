if (hitpoints == 0) {return;}

// Loop through all existing ghost effect structs and render them at their current positions and opacity levels.
for (var i = 0; i < PLYR_NUM_GHOST_EFFECTS; i++) 
	ghostEffectIDs[i].draw();

// Call the entity's default drawing function, which handles rendering Samus herself, and attempt to draw her arm
// cannon, but only if her main sprite is allowed to be drawn; overriding the cannon's own visibility flag.
entity_draw();
if (ENTT_CAN_DRAW_SELF) 
	armCannon.draw();

// Don't flicker Samus's sprite if she's no longer in her hitstun/recovery phase.
if (!PLYR_CAN_SPRITE_FLICKER) {return;}

// Increment timer until the required amount of time has passed to create a uniform flicker that isn't tied to the
// current frame rate, which is heavily variable.
flickerTimer += DELTA_TIME;
if (flickerTimer >= PLYR_HIT_INTERVAL){
	if (ENTT_CAN_DRAW_SELF) {stateFlags &= ~ENTT_DRAW_SELF;}
	else					{stateFlags |=	ENTT_DRAW_SELF;}
	flickerTimer -= PLYR_HIT_INTERVAL;
}

// Rest Samus back to visible and clear the flag that causes Samus to flicker whenever she is no longer hitstunned
// or in her damage recovery phase.
if (hitstunTimer == -1.0 && recoveryTimer == -1.0){
	stateFlags &= ~PLYR_SPRITE_FLICKER;
	stateFlags |=  ENTT_DRAW_SELF;
}