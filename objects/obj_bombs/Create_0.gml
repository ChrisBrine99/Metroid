#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Bombs and make sure its collision mask is completely disabled. Then, set
// the proper values for the Bombs's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_bombs, spr_empty_mask);
flagBit = FLAG_BOMBS;
itemID	= ID_BOMBS;

// Setup the ambient light source to match the Bomb Tank's color scheme.
baseRadius = 24;
baseStrength = 0.5;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_BLUE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion