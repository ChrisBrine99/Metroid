#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Set the proper sprite for the Space Jump and make sure its collision mask is completely disabled. Then, set 
// the proper values for the Space Jump's corresponding event flag bit and internal item ID.
entity_set_sprite(spr_space_jump, spr_empty_mask);
flagBit = FLAG_SPACE_JUMP;
itemID	= ID_SPACE_JUMP;

// Setup the ambient light source to match the Space Jump's color scheme.
baseRadius = 34;
baseStrength = 0.8;
object_add_light_component(x, y, 0, -2, baseRadius, HEX_LIGHT_BLUE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

/// @description Override the default function in order to allow Samus's somersaulting animation to be replaced
/// by the relevant Space Jump somersault animation for the suit she currently has equipped.
collectible_apply_effects = function(){
	// Don't overwrite the animation if Samus already has the Screw Attack.
	if (event_get_flag(FLAG_SCREW_ATTACK)) 
		return;
	
	// Update the somersaulting animation should Samus not have the Screw Attack.
	with(PLAYER){
		var _hasGravity = event_get_flag(FLAG_GRAVITY_SUIT);
		if (!_hasGravity && event_get_flag(FLAG_VARIA_SUIT)) // Currently wearing the Varia Suit.
			jumpSpriteSpin = spr_power_jump0a;
		else if (_hasGravity) // Currently wearing the Gravity Suit.
			jumpSpriteSpin = spr_power_jump0a;
		else // Currently wearing the standard Power Suit.
			jumpSpriteSpin = spr_power_jump0a;
	}
}

#endregion