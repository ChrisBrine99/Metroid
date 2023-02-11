#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_spring_ball, spr_empty_mask);
flagID = FLAG_SPRING_BALL;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Spring Ball";
collectibleInfo = "Grants the ability to jump while Samus is in her \"Morph Ball\" form.";
// Setup the ambient light source to match the spring ball's color scheme.
baseRadius = 28;
baseStrength = 0.6;
object_add_light_component(x, y, 7, 4, baseRadius, HEX_LIGHT_PURPLE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion