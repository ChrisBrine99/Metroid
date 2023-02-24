// Loop through all existing jump effect structs and render them at their current positions and opacity levels.
var _length = ds_list_size(jumpEffectID);
for (var i = 0; i < _length; i++) {jumpEffectID[| i].draw();}

// Call the entity's default drawing function, which handles rendering Samus herself, and attempt to draw her arm
// cannon, but only if her main sprite is allowed to be drawn; overriding the cannon's own visibility flag.
entity_draw();
if (CAN_DRAW_SPRITE) {armCannon.draw();}