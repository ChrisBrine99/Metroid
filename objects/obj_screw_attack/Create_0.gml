#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Screw Attack and make sure its collision mask is completely disabled. Then, set 
// the proper values for the Screw Attack's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_screw_attack, spr_empty_mask);
flagBit = FLAG_SCREW_ATTACK;
itemID	= ID_SCREW_ATTACK;

// Setup the ambient light source to match the Screw Attack's color scheme.
baseRadius = 26;
baseStrength = 0.65;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_ORANGE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Override the default function in order to allow Samus's somersaulting animation to be replaced
/// by the relevant Screw Attack animation based on the suit she is currently wearing.
collectible_apply_effects = function(){
	with(PLAYER){
		var _hasGravity = event_get_flag(FLAG_GRAVITY_SUIT);
		if (!_hasGravity && event_get_flag(FLAG_VARIA_SUIT)) // Currently wearing the Varia Suit.
			jumpSpriteSpin = spr_power_jump0b;
		else if (_hasGravity) // Currently wearing the Gravity Suit.
			jumpSpriteSpin = spr_power_jump0b;
		else // Currently wearing the standard Power Suit. 
			jumpSpriteSpin = spr_power_jump0b;
	}
}

#endregion