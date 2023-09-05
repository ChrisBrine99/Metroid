if (hitpoints == 0) {return;}

// Loop through all existing ghost effect structs and render them at their current positions and opacity levels.
var _length = ds_list_size(ghostEffectID);
for (var i = 0; i < _length; i++) {ghostEffectID[| i].draw();}

// Call the entity's default drawing function, which handles rendering Samus herself, and attempt to draw her arm
// cannon, but only if her main sprite is allowed to be drawn; overriding the cannon's own visibility flag.
entity_draw();
if (CAN_DRAW_SPRITE) {armCannon.draw();}

// Don't flicker Samus's sprite if she's no longer in her hitstun/recovery phase.
if (!IS_HIT_STUNNED) {return;}

flickerTimer += DELTA_TIME;
if (flickerTimer >= SPRITE_FLICKER_INTERVAL){
	if (CAN_DRAW_SPRITE) {stateFlags &= ~(1 << DRAW_SPRITE);}
	else				 {stateFlags |=	 (1 << DRAW_SPRITE);}
	flickerTimer -= SPRITE_FLICKER_INTERVAL;
}