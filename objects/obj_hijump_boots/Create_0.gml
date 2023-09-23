#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_hijump_boots, spr_empty_mask);
flagID = FLAG_HIJUMP_BOOTS;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Hi-Jump Boots";
collectibleInfo = "Samus's maximum jumping height has been drastically increased!";
// Setup the ambient light source to match the hi-jump boots' color scheme.
baseRadius = 32;
baseStrength = 0.7;
object_add_light_component(x, y, -1, 0, baseRadius, HEX_LIGHT_RED, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Updates Samus's "maxVspd" variable to reflect the new jump height allowed by this item.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER) {maxVspd = PLYR_UPGRADED_JUMP;}
}

#endregion