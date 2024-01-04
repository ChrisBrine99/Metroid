#region Macros that are useful/related to obj_energy_tank

// ------------------------------------------------------------------------------------------------------- //
//	Stores the value that the energy tank adds onto Samus's current energy capacity when collected.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_TANK_CAPACITY	100

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Small Missile Tank and make sure its collision mask is completely disabled. 
// Then, set the proper value for the Small Missile Tank's internal item ID.
entity_set_sprite(spr_energy_tank, spr_empty_mask);
itemID = ID_ENERGY_TANK;

// Setup the ambient light source to match the Energy Tank's color scheme.
baseRadius = 32;
baseStrength = 0.5;
object_add_light_component(x, y, 0, -4, baseRadius, HEX_LIGHT_PURPLE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Permanently increase Samus's energy capcity by 100 units. Also increases her current energy
/// by the same amount of units.
collectible_apply_effects = function(){
	with(PLAYER) {update_maximum_energy(ENERGY_TANK_CAPACITY);}
}

#endregion