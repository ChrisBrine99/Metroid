/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

event_inherited();
// By default, all explosion effects will animate in some way or form
projectileAnimates = true;
// Explosions that deal damage don't apply to standard collisions, so they will be ignored.
ignoreCollision = true;

#endregion


#region FUNCTION INITIALIZATION

/// @description Condenses all the code that would normally be used to create an explosion effect with all
/// the necesary variables set and in place into a single call from whatever creates this object.
/// @param state
/// @param damage
/// @param sprite
/// @param lightSize
/// @param lightStrength
/// @param lightColor
function create_explosion(_state, _damage, _type, _sprite, _lightSize, _lightStrength, _lightColor){
	set_cur_state(_state);
	// Set the damage of the explosion effect, a damage of 0 or less will be ignored for collisions
	damage = _damage;
	// Set the projectile's type, which is used to determine if an enemy takes damage from the explosion or not
	projectileType = _type;
	// Get the sprite's data after setting it's index
	sprite_index = _sprite;
	spriteSpeed = sprite_get_speed(sprite_index);
	spriteNumber = sprite_get_number(sprite_index);
	// Finally, create the ambient light source and apply its size, strength, and color
	entity_create_light(0, 0, _lightSize, _lightSize, _lightStrength, _lightColor);
}

#endregion