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
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_power_bomb_tank, spr_empty_mask);
flagID = POWER_BOMB_TANK0;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Power Bomb Tank";
collectibleInfo = "Samus's power bomb capacity has been permanently increased by one!";
// Setup the ambient light source to match the energy tank's color scheme.
baseRadius = 24;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_YELLOW, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Increases Samus's current and maximum power bomb values by one unit.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER) {update_maximum_power_bombs(PBOMB_TANK_CAPACITY);}
}

#endregion