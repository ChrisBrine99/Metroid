#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// The mumbo will move left to right; reversing its horizontal direction once it hits a wall. However, it will
// also slowly move towards Samus's direction along the vertical axis, so its max vertical velocity is set low.
maxHspd = 0.5;
maxVspd = 0.05;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Mumbo will be able to take
// four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Mumbo. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 8;
stunDuration	= 8;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.45;	// 45%
aeionDropChance		= 0.20;	// 20%
ammoDropChance		= 0.30;	// 30%

#endregion

#region Unique variable initialization

// Determines the direction that the Mumbo is currently moving in; right or left.
movement = 0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Mumbo, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Mumbo. It sets its sprite, creates an ambient light for its
/// "eye/visor", and sets it to be weak to all forms of weaponry. On top of that, its initial state is set 
/// while its starting movement direction being randomly determined between left (-1) and right (+1).
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_mumbo, -1);
	object_add_light_component(x, y, 0, 0, 10, HEX_LIGHT_GREEN, 0.65);
	create_general_collider();
	initialize_weak_to_all();
	movement = choose(-1, 1);
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// Don't update the Mumbo's position if it isn't on screen to prevent it from reaching Samus's y position
	// before it is actually first seen on camera by the player within the current room.
	if (!ENTT_IS_ON_SCREEN) {return;}
	
	// Process horizontal and vertical movement. The horizontal velocity being determined by the Mumbo's current
	// movement direction; with the vertical velocity determined by Samus's y position relative to the Mumbo's
	// current y position.
	hspd = maxHspd * movement;
	var _yy = y;
	with(PLAYER){ // Center target on middle of Samus whether she's in her morphball form or not.
		if (PLYR_IN_MORPHBALL)	{_yy = sign(PLAYER.y - 8 - _yy);}
		else					{_yy = sign(PLAYER.y - 20 - _yy);}
	}
	vspd = maxVspd * _yy;
	
	// Finally, process the movement for the frame using the standard entity world collision function. After
	// that, check for a horizontal collision relative to the Mumbo's movement direction so it can flip said
	// direction of movement.
	apply_frame_movement(entity_world_collision);
	if (place_meeting(x + movement, y, par_collider)) 
		movement *= -1;
}

#endregion

// Once the create event has executed, initialize the Mumbo by setting it to its default state function.
initialize(state_default);