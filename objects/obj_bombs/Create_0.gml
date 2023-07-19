#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_bombs, spr_empty_mask);
flagID = FLAG_BOMBS;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Bombs";
collectibleInfo = "The Morph Ball can now deploy bombs that can destroy blocks in the world and damage hostile targets.";
// Setup the ambient light source to match the bomb tank's color scheme.
baseRadius = 24;
baseStrength = 0.5;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_BLUE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion