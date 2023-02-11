#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_morph_ball, spr_empty_mask);
flagID = FLAG_MORPHBALL;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Morph Ball";
collectibleInfo = "Allows Samus to roll herself into a ball to gain access through narrow passageways.";
// Setup the ambient light source to match the morph ball's color scheme.
baseRadius = 32;
baseStrength = 0.7;
object_add_light_component(x, y, 8, 8, baseRadius, HEX_LIGHT_ORANGE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion