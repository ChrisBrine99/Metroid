if (hitpoints == 0) {return;}

// Loop through all existing ghost effect structs and render them at their current positions and opacity levels.
var _length = ds_list_size(ghostEffectID);
for (var i = 0; i < _length; i++) {ghostEffectID[| i].draw();}

// Call the entity's default drawing function, which handles rendering Samus herself, and attempt to draw her arm
// cannon, but only if her main sprite is allowed to be drawn; overriding the cannon's own visibility flag.
entity_draw();
if (CAN_DRAW_SPRITE) {armCannon.draw();}
draw_sprite_ext(spr_rectangle, 0, bbox_left, bbox_top, (bbox_right - bbox_left), (bbox_bottom - bbox_top), 0, collisionMaskColor, 0.5);

// Don't flicker Samus's sprite if she's no longer in her hitstun/recovery phase. If she is, her sprite visibility
// with be toggled on and off on a per-frame basis.
if (!IS_HIT_STUNNED) {return;}
stateFlags = CAN_DRAW_SPRITE ? stateFlags & ~(1 << DRAW_SPRITE) : stateFlags | (1 << DRAW_SPRITE);