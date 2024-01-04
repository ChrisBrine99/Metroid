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

/// @description 
collectible_apply_effects = function(){
	if (event_get_flag(FLAG_SCREW_ATTACK)) 
		return;
		
	with(PLAYER){
		if (event_get_flag(FLAG_VARIA_SUIT))		{jumpSpriteSpin = spr_power_jump0a;}
		else if (event_get_flag(FLAG_GRAVITY_SUIT))	{jumpSpriteSpin = spr_power_jump0a;}
		else										{jumpSpriteSpin = spr_power_jump0a;}
	}
}

#endregion