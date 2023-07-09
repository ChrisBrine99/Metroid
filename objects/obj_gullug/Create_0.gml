#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// 
entity_set_sprite(spr_enemy, -1);

// Since te Power Beam deals a single point of damage (On "Normal" difficulty), the Gullug will be able to take
// four hits before dying.
maxHitpoints = 4;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Gullug. These values are increased/decreased by the
// difficulty level selected by the player.
damage = 10;
stunDuration = 10;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance = 0.3;		// 35%
aeionDropChance = 0.2;		// 20%
ammoDropChance = 0.2;		// 20%

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

/// @description 
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