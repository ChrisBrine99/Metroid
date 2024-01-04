#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Morph Ball and make sure its collision mask is completely disabled. Then, set
// the proper values for the Morph Ball's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_morph_ball, spr_empty_mask);
flagBit = FLAG_MORPHBALL;
itemID	= ID_MORPH_BALL;

// Setup the ambient light source to match the morph ball's color scheme.
baseRadius		= 32;
baseStrength	= 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_ORANGE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion