#region Macros that are useful/related to obj_reserve_tank

// ------------------------------------------------------------------------------------------------------- //
//	Stores the value that the reserve tank adds onto Samus's current energy reserve capacity when		   //
//	collected.																							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	RESERVE_TANK_CAPACITY	100

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Reserve Tank and make sure its collision mask is completely disabled. Then, 
// set the proper value for the Reserve Tank's internal item ID.
entity_set_sprite(spr_reserve_tank, spr_empty_mask);
itemID = ID_RESERVE_TANK;

// Setup the ambient light source to match the Reserve Tank's color scheme.
baseRadius = 32;
baseStrength = 0.5;
object_add_light_component(x, y, 0, -4, baseRadius, HEX_WHITE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Permanently increase Samus's reserve energy capacity by 100 units. The tank itself is empty,
/// so no energy is actually added to her current reserves.
collectible_apply_effects = function(){
	with(PLAYER) {maxReserveHitpoints += RESERVE_TANK_CAPACITY;}
}

#endregion