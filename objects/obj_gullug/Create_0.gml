#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the proper sprite, and add a dim ambient light for the Gullug's eyes; the light matching the eye color
// in the sprite itself. Finally, the Gullug is set to be susceptible to every weapon Samus has access to.
entity_set_sprite(spr_gullug, -1);
object_add_light_component(x, y, 0, -5, 14, HEX_LIGHT_PURPLE, 0.5);
initialize_weak_to_all();

// Since te Power Beam deals a single point of damage (On "Normal" difficulty), the Gullug will be able to take
// eight hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints = 8;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Gullug. These values are increased/decreased by the
// difficulty level selected by the player.
damage = 10;
stunDuration = 10;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance = 0.35;	// 35%
aeionDropChance = 0.3;		// 30%
ammoDropChance = 0.3;		// 30%

#endregion

#region Unique variable initialization

// Stores the initial position of the Gullug, which will determine the center point of the cirle it will
// rotate around when in its default state.
startX			= x;
startY			= y;

// Determines how fast the Gullug will rotate around its "start" coordinates. The direction can be set to -1
// or +1 to change the direction of movement, and the radius will determine how far from those "start"
// coordinates the Gullug will circle.
moveSpeed		= 2;
moveDirection	= choose(1, -1);
radius			= 48;

#endregion

#region State function initialization

/// @description The Gullug's default/dormant state. While in this state, they will simply circle around a
/// point endlessly. If there is a line of sight between the Gullug and Samus, it will try charging at her.
/// Otherwise, it will remain in this state indefinitely.
state_default = function(){
	x = startX + lengthdir_x(radius, direction);
	y = startY + lengthdir_y(radius, direction);
	direction += moveDirection * moveSpeed * DELTA_TIME;
}

#endregion

// Set the Gullug to its default state; choosing either the top or bottom of the circle it will move along
// as its starting position.
object_set_next_state(state_default);
y = startY + lengthdir_y(radius, choose(90, 270));