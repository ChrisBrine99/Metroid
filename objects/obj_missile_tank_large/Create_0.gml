#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Amount added to Samus's missile ammunition reserve when she collects this type of missile tank.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LARGE_MTANK_CAPACITY	10

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_large_missile_tank, spr_empty_mask);
flagID = LARGE_MISSILE_TANK0;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Large Missile Tank";
collectibleInfo = "Samus's missile capacity has been permanently increased by ten!";
// Change the fanfare to a shortened version for all large missile tanks.
fanfare = mus_missile_tank_found;
// Setup the ambient light source to match the energy tank's color scheme.
baseRadius = 30;
baseStrength = 0.7;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_WHITE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Increases Samus's current and maximum missile capaciy values by two.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER) {update_maximum_missiles(LARGE_MTANK_CAPACITY);}
}

#endregion