#region Macro initialization

// 
#macro	HRND_JMP_COOLDOWN_TIME	90.0
#macro	HRND_FACING_LOCK_TIME	10.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// 
maxHspd = 1.8;
maxVspd = -4.0;

//
vAccel = 0.25;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Hornoad will be able to 
// take eight hits before dying. Other beams and missiles will change the amount of hits needed.
maxHitpoints	= 8;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Hornoad. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 16;
stunDuration	= 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.40;	// 40%
aeionDropChance		= 0.30;	// 30%
ammoDropChance		= 0.25;	// 25%

#endregion

#region Unique variable intializations

// Determines the direction that the Hornoad faces and the direction it will jump toward whenever it does
// execute its jumping state.
movement = 0;

// Timer for tracking how long it has been since the Hornoad last jumped. Until this value surpasses the required
// amount of time (The macro "HRND_JUMP_INTERVAL" stores said amount), the Hornoad will remain on the ground.
jumpTimer = 0.0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Halzyn, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description 
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_hornoad0, -1);
	object_add_light_component(x, y, 4, -6, 10, HEX_LIGHT_RED, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	
	// Randomly choose a starting direction upon initialization.
	movement	 = choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	lightOffsetX = 4 * movement;
	image_xscale = movement;
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// 
	jumpTimer += DELTA_TIME;
	if (jumpTimer > HRND_JMP_COOLDOWN_TIME){
		object_set_next_state(state_airbourne);
		entity_set_sprite(spr_hornoad1, -1);
		stateFlags &= ~(1 << GROUNDED);
		hspd		= maxHspd * movement;
		vspd		= maxVspd;
		jumpTimer	= 0.0;
		return;
	}
	
	// Wait until the "jumpTimer" variable surpasses the small buffer interval so the Hornoad can't instantly
	// switch directions upon landing, which it would do without this check.
	if (jumpTimer < HRND_FACING_LOCK_TIME) {return;}
	
	// Compare the x position of the player against the Hornoad. If the difference is bigger than 8 relative
	// to the direction the Hornoad is currently facing, it will switch facing and movement directions.
	var _xDifference = PLAYER.x - x;
	if (_xDifference > 8 && movement == MOVE_DIR_LEFT){
		movement	 = MOVE_DIR_RIGHT;
		image_xscale = MOVE_DIR_RIGHT;
		lightOffsetX = 4;
	} else if (_xDifference < -8 && movement == MOVE_DIR_RIGHT){
		movement	 = MOVE_DIR_LEFT;
		image_xscale = MOVE_DIR_LEFT;
		lightOffsetX = -4;
	}
}

/// @description 
state_airbourne = function(){
	// 
	apply_gravity(MAX_FALL_SPEED);
	if (IS_GROUNDED){
		object_set_next_state(state_default);
		entity_set_sprite(spr_hornoad0, -1);
		hspd = 0.0;
		vspd = 0.0;
		return;
	}
	
	// 
	apply_frame_movement(entity_world_collision);
}

#endregion

// Set the Hornoad to its default state upon creation.
initialize(state_default);