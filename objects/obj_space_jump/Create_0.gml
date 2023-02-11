#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_space_jump, spr_empty_mask);
flagID = FLAG_SPACE_JUMP;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Space Jump";
collectibleInfo = "Allows Samus to jump again while she is somersaulting in the air.";
// Setup the ambient light source to match the space jump's color scheme.
baseRadius = 34;
baseStrength = 0.8;
object_add_light_component(x, y, 8, 6, baseRadius, HEX_LIGHT_BLUE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description Updates Samus's somersaulting sprite to the space jump's animation for whatever suit she
/// currently has equipped. However, the sprite isn't updated if she already has access to the screw attack.
collectible_collect_self = function(){
	__collectible_collect_self();
	if (event_get_flag(FLAG_SCREW_ATTACK)) {return;}
	with(PLAYER){
		if (event_get_flag(FLAG_VARIA_SUIT))		{jumpSpriteSpin = spr_power_jump0a;}
		else if (event_get_flag(FLAG_GRAVITY_SUIT))	{jumpSpriteSpin = spr_power_jump0a;}
		else										{jumpSpriteSpin = spr_power_jump0a;}
	}
}

#endregion