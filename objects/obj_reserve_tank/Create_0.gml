#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_reserve_tank, spr_empty_mask);
flagID = RESERVE_TANK0;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Reserve Tank";
collectibleInfo = "A special type of energy tank that will store excess energy that is utilized if Samus ever loses all of her current energy. Each tank can store an additional 100 units.";
// Setup the ambient light source to match the energy tank piece's color scheme.
baseRadius = 32;
baseStrength = 0.5;
object_add_light_component(x, y, 8, 10, baseRadius, HEX_WHITE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Increases Samus's energy tank reserve space by another 100 units; doesn't provide an additional
/// 100 energy to the reserve like a standard energy tank does for Samus's main energy amount upon collection.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER) {maxReserveHitpoints += 100;}
}

#endregion