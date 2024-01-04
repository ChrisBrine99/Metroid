#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the High-Jump Boots and make sure its collision mask is completely disabled. Then, 
// set the proper values for the High-Jump Boots's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_hijump_boots, spr_empty_mask);
flagBit = FLAG_HIJUMP_BOOTS;
itemID	= ID_HIGH_JUMP_BOOTS;

// Setup the ambient light source to match the High-Jump Boots's color scheme.
baseRadius = 32;
baseStrength = 0.7;
object_add_light_component(x, y, -1, 0, baseRadius, HEX_LIGHT_RED, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Override the default function in order to allow Samus's maximum jumping velocity to be
/// increased by the acquisition of the High Jump Boots.
collectible_apply_effects = function(){
	with(PLAYER) {maxVspd = PLYR_UPGRADED_JUMP;}
}

#endregion