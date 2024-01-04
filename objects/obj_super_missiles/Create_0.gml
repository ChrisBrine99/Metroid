#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Super Missile and make sure its collision mask is completely disabled. Then, 
// set the proper values for the Super Missile's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_super_missiles, spr_empty_mask);
flagBit = FLAG_SUPER_MISSILES;
itemID	= ID_SUPER_MISSILES;

// Setup the ambient light source to match the Super Missile's color scheme.
baseRadius = 32;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_WHITE, baseStrength);

#endregion

#region Unique variable initialization
#endregion