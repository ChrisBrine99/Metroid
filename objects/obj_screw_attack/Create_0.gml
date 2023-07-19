#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the sprite to match the one set in the object section (This one is only set so it can be placed inside
// the game's room without causing confusion due to the sprite actually being set in code) and also set the bit
// that the collectible will use.
entity_set_sprite(spr_screw_attack, spr_empty_mask);
flagID = FLAG_SCREW_ATTACK;
// Set the collectible's name and information to match what this child object represents in the code.
collectibleName = "Screw Attack";
collectibleInfo = "Samus's spin jump will now produce a dangerous field of electricity around her; damaging anything she comes into contact with.";
// Setup the ambient light source to match the screw attack orb's color scheme.
baseRadius = 26;
baseStrength = 0.65;
object_add_light_component(x, y, 0, 0, baseRadius, HEX_LIGHT_ORANGE, baseStrength);

#endregion

#region Unique variable initialization
#endregion

#region Editing collection function

// Stores the parent function in another variable so it can be called through the overrided version found
// within this child object. Otherwise, that original function's code would be unaccessible.
__collectible_collect_self = collectible_collect_self;
/// @description 
collectible_collect_self = function(){
	__collectible_collect_self();
	with(PLAYER){
		jumpSpriteSpin = spr_power_jump0b;
	}
}

#endregion