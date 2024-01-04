#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Stores the value added to Samus's power bomb ammo capacity when she collects one of their tanks.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PBOMB_TANK_CAPACITY		1

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Power Bomb Tank and make sure its collision mask is completely disabled. Then, 
// set the proper value for the Power Bomb Tank's internal item ID.
entity_set_sprite(spr_power_bomb_tank, spr_empty_mask);
itemID = ID_POWER_BOMB_TANK;

// Setup the ambient light source to match the Power Bomb Tank's color scheme.
baseRadius = 24;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_YELLOW, baseStrength);

// Change the fanfare to a shortened version for all Power Bomb Tanks.
fanfare = mus_missile_tank_found;

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Increases Samus's current and maximum power bomb values by one unit.
collectible_apply_effects = function(){
	with(PLAYER) {update_maximum_power_bombs(PBOMB_TANK_CAPACITY);}
}

#endregion