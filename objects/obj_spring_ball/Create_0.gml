#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Spring Ball and make sure its collision mask is completely disabled. Then, set
// the proper values for the Spring Ball's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_spring_ball, spr_empty_mask);
flagBit = FLAG_SPRING_BALL;
itemID	= ID_SPRING_BALL;

// Setup the ambient light source to match the Spring Ball's color scheme.
baseRadius = 28;
baseStrength = 0.6;
object_add_light_component(x, y, -1, -4, baseRadius, HEX_LIGHT_PURPLE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function
#endregion