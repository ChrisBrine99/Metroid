#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the proper sprite, and add a dim ambient light for the Ripper's eyes; the light matching the eye color
// in the sprite itself. Finally, the Ripper is set to be susceptible to every weapon Samus has access to.
entity_set_sprite(spr_ripper, -1);
object_add_light_component(x, y, 7, 2, 8, HEX_LIGHT_BLUE, 0.6);
// Rippers have no weakness aside from super missiles and power bombs (Power Bombs don't count as a weakness
// since they're effective against ALL enemies/bosses in the game).
ds_list_add(weaknesses, (1 << TYPE_SUPER_MISSILE));

// Set the maximum horizontal speed and acceleration for the Ripper. Its speed is set to 0 after it bounces
// off a wall, and as such will smoothly speed back up to its max velocity.
maxHspd = 0.8;
hAccel	= 0.2;

// Despite being invulnerable to nearly all forms of weaponry that Samus can utilize, the ripper will only
// have a single point of hp within the code; guarenteeing its death against super missiles or a power bomb.
// Having an HP value of one also allows the ripper to be frozen even if it isn't damaged by the ice-based
// weapon utilized.
maxHitpoints = 1;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Ripper. These values are increased/decreased by the
// difficulty level selected by the player.
damage = 10;
stunDuration = 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here. Rippers will almost always drop ammunition.
energyDropChance = 0.0;		// 0%
aeionDropChance = 0.0;		// 0%
ammoDropChance = 0.9;		// 90%

#endregion

#region Unique variable initialization

// Determines the direction that the Ripper is currently moving in; right or left. It is randomly set upon a
// Ripper instance's creation so they don't all start in the same direction.
movement = choose(1, -1);

#endregion

#region State function initialization

/// @description The Ripper's default state. All it will do is bounce back and forth between two walls; one
/// to its left and one to its right; flipping to the opposite direction on contact with each.
state_default = function(){
	hspd += movement * hAccel * DELTA_TIME;		// Update horizontal velocity.
	if (hspd > maxHspd || hspd < -maxHspd) {hspd = maxHspd * movement;}
	
	var _deltaHspd = hspd * DELTA_TIME;						// Remove decimal values from velocity.
	var _signHspd = sign(_deltaHspd);
	_deltaHspd += hspdFraction;
	hspdFraction = _deltaHspd - (floor(abs(_deltaHspd)) * _signHspd);
	_deltaHspd -= hspdFraction;
	
	if (place_meeting(x + _deltaHspd, y, par_collider)){	// Handling collision.
		while(!place_meeting(x + _signHspd, y, par_collider)) {x++;}
		lightOffsetX *= -1;			// Flip eye light's position
		movement *= -1;				// Flip movement direction
		imageIndex++;
		hspd = 0.0;
		return;
	}
	x += _deltaHspd;
}

// Start the Ripper off in its default state. The light's horizontal offset and active sprite are determined
// by the result of the coin flip that determined the initial movement direction; facing left if required.
object_set_next_state(state_default);
if (movement == -1){
	lightOffsetX *= -1;
	imageIndex = 1;
}

#endregion