#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Wave Beam and make sure its collision mask is completely disabled. Then, set 
// the proper values for the Wave Beam's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_wave_beam, spr_empty_mask);
flagBit = FLAG_WAVE_BEAM;
itemID	= ID_WAVE_BEAM;

// Setup the ambient light source to match the Wave Beam's color scheme.
baseRadius = 40;
baseStrength = 0.5;
object_add_light_component(x, y, 4, -4, baseRadius, HEX_LIGHT_PURPLE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Override the default function in order to make Samus equip the Wave Beam upon collection.
collectible_apply_effects = function(){
	with(PLAYER){
		inputFlags |= (1 << PLYR_WAVBEAM);
		check_swap_current_weapon();
	}
}

#endregion