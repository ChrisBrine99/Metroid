#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_ice_beam, spr_empty_mask);
flagID = FLAG_ICE_BEAM;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Ice Beam";
collectibleInfo = "Adds a new beam to Samus's arm cannon. The ice beam can freeze items and the environment; creating new platforms that Samus can temporarily stand on. On top of that, it can open light blue doors.";
// Setup the ambient light source to match the ice beam totem's color scheme.
baseRadius = 40;
baseStrength = 0.5;
object_add_light_component(x, y, 12, 4, baseRadius, HEX_LIGHT_BLUE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Switches Samus's currently equipped beam over to this newly collected ice beam.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER){
		inputFlags |= (1 << SWAP_ICE_BEAM);
		check_swap_current_weapon();
	}
}

#endregion