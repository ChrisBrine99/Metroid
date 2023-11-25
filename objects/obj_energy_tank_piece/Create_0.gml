#region

// ------------------------------------------------------------------------------------------------------- //
//	Stores the number of energy tank piece Samus will need to have collected before they can be converted  //
//	into an energy tank, which gives her a 100 point boost to her current energy capacity.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	NEEDED_ETANK_PIECES		4

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_energy_tank_piece, spr_empty_mask);
flagID = ENERGY_TANK_PIECE0;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Energy Tank Piece";
collectibleInfo = "A small energy piece. When four are combined, Samus's maximum energy will be increased by 100 units.";
// Change the fanfare to a shortened version for all energy tank pieces.
fanfare = mus_minor_item_found;
// Setup the ambient light source to match the energy tank piece's color scheme.
baseRadius = 24;
baseStrength = 0.4;
object_add_light_component(x, y, 0, 2, baseRadius, HEX_PURPLE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Increments Samus's current number of collected energy tank pieces. Once that values reaches
/// the required amount, all four will be discarded and Samus will be given an additional 100 units of energy
/// permanently.
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER){
		energyTankPieces++;
		if (energyTankPieces == NEEDED_ETANK_PIECES){
			update_maximum_energy(ENERGY_TANK_CAPACITY);
			energyTankPieces = 0;	// Reset number of eTank pieces.
		}
	}
}

#endregion