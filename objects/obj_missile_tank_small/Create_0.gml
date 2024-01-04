#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Amount added to Samus's missile ammunition reserve when she collects this type of missile tank.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	SMALL_MTANK_CAPACITY	2

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Small Missile Tank and make sure its collision mask is completely disabled. 
// Then, set the proper value for the Small Missile Tank's internal item ID.
entity_set_sprite(spr_small_missile_tank, spr_empty_mask);
itemID = ID_MISSILE_TANK_SMALL;

// Setup the ambient light source to match the Small Missile Tank's color scheme.
baseRadius = 24;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_WHITE, baseStrength);

// Change the fanfare to a shortened version for all Small Missile Tanks.
fanfare = mus_missile_tank_found;

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Increases Samus's current and maximum missile capaciy values by two.
collectible_apply_effects = function(){
	with(PLAYER) {update_maximum_missiles(SMALL_MTANK_CAPACITY);}
}

#endregion