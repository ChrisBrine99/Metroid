#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_energy_tank, spr_empty_mask);
flagID = ENERGY_TANK0;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Energy Tank";
collectibleInfo = "Samus's maximum energy capacity has been permanently increased by 100 units.";
// Setup the ambient light source to match the energy tank's color scheme.
baseRadius = 32;
baseStrength = 0.5;
object_add_light_component(x, y, 8, 4, baseRadius, HEX_LIGHT_PURPLE, baseStrength);

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
	with(PLAYER){ // Increases current hitpoints by 100 since the energy tank is full.
		maxHitpoints += 100;
		hitpoints += 100;
	}
}

#endregion