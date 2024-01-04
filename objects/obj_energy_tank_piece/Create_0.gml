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

// Set the proper sprite for the Energy Tank Piece and make sure its collision mask is completely disabled. 
// Then, set the proper value for the Energy Tank Piece's internal item ID.
entity_set_sprite(spr_energy_tank_piece, spr_empty_mask);
itemID = ID_ENERGY_TANK_PIECE;

// Setup the ambient light source to match the Energy Tank Piece's color scheme.
baseRadius = 24;
baseStrength = 0.4;
object_add_light_component(x, y, 0, 2, baseRadius, HEX_PURPLE, baseStrength);

// Change the fanfare to a shortened version for all Energy Tank Pieces.
fanfare = mus_missile_tank_found;

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Increment the current number of held energy tank pieces by one. If the value held equals
/// four, Samus will be granted 100 units to her maximum energy capacity, and it will reset the count to 0.
collectible_apply_effects = function(){
	with(PLAYER){
		energyTankPieces++;
		if (energyTankPieces == NEEDED_ETANK_PIECES){
			update_maximum_energy(ENERGY_TANK_CAPACITY);
			energyTankPieces = 0;	// Reset number of eTank pieces.
		}
	}
}

#endregion