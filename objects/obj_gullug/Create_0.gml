#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Gullug will be able to take
// eight hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 8;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Gullug. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 10;
stunDuration	= 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.35;	// 35%
aeionDropChance		= 0.3;	// 30%
ammoDropChance		= 0.3;	// 30%

#endregion

#region Unique variable initialization

// Stores the initial position of the Gullug, which will determine the center point of the cirle it will
// rotate around when in its default state.
startX			= 0;
startY			= 0;

// Determines how fast the Gullug will rotate around its "start" coordinates. The direction can be set to -1
// or +1 to change the direction of movement, and the radius will determine how far from those "start"
// coordinates the Gullug will circle.
moveSpeed		= 0;
moveDirection	= 0;
radius			= 0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Gullug, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Gullug. It sets its sprite, creates an ambient light for its
/// eyes, and sets it to be weak to all forms of weaponry. On top of that, its initial state is set while its 
/// starting movement direction is randomly determined between left (-1) and right (+1); the starting position
/// being determined as either the top (90) or bottom (270) of its movement circle.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_gullug, -1);
	object_add_light_component(x, y, 0, -5, 14, HEX_LIGHT_PURPLE, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	
	startX			= x;	// Set "center" of the Gullug's movement circle to its initial position.
	startY			= y;
	moveSpeed		= 2;	// Set movement speed and randomly determine to move left (-1) or right (+1).
	moveDirection	= choose(1, -1);
	radius			= 48;	// How "large" the Gullug's movement area is.
	
	// Start the Gullug at either the top (90) or bottom (270) of its movement circle by said value being
	// randomly chosen upon the Gullu's initialization.
	direction		= choose(90, 270);
	y				= startY + lengthdir_y(radius, direction);
}

#endregion

#region State function initialization

/// @description The Gullug's default/dormant state. While in this state, they will simply circle around a
/// point endlessly. If there is a line of sight between the Gullug and Samus, it will try charging at her.
/// Otherwise, it will remain in this state indefinitely.
state_default = function(){
	x = startX + lengthdir_x(radius, direction);
	y = startY + lengthdir_y(radius, direction);
	direction += moveDirection * moveSpeed * DELTA_TIME;
	// TODO -- Fix to prevent sub-pixel position values.
}

#endregion

// Once the create event has executed, initialize the Gullug by setting it to its default state function.
initialize(state_default);