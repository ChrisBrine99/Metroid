#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// 
maxHspd = 1.0;
maxVspd = 2.0;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Halzyn will be able to take
// a massive sixteen hits before dying. Other beams and missiles will change the amount of hits needed.
maxHitpoints	= 16;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Halzyn. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 30;
stunDuration	= 18;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.35;	// 35%
aeionDropChance		= 0.35;	// 35%
ammoDropChance		= 0.20;	// 20%

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Halzyn, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Halzyn. It sets its sprite, and sets it to be weak to all 
/// forms of weaponry. 
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_halzyn, -1);
	initialize_weak_to_all();
	create_weapon_collider(-6, -5, 12, 12);				// Vulnerable collider
	create_weapon_collider(-14, -10, 8, 20, true);		// Left wing
	create_weapon_collider(6, -10, 8, 20, true);		// Right wing
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	direction  += DELTA_TIME * 5.0;
	vspd		= lengthdir_y(maxVspd, direction);
	y += vspd * DELTA_TIME;
}

// Set the Halzyn to its default state upon creation.
initialize(state_default);

#endregion