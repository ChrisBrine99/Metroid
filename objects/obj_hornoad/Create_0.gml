#region Macro initialization

// Important timer values that determine what the Hornoad is able to do when in its default state. The first
// determines how long in unit frames until the Hornoad is able to jump again (60 units = 1 second), and the
// second determines how long must pass before the Hornoad can change facing directions after landing.
#macro	HRND_JMP_COOLDOWN_TIME	100.0
#macro	HRND_FACING_LOCK_TIME	15.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum horizontal and vertical velocities for the Hornoad; both of which are only ever utilized
// when its in its jumping state.
maxHspd = 1.8;
maxVspd = -4.0;

// Set the force of gravity against the Hornoad, which is the same amount that is applied to Samus.
vAccel = 0.25;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Hornoad will be able to 
// take four hits before dying. Other beams and missiles will change the amount of hits needed.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Hornoad. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 8;
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
jumpTimer		= 0.0;
jumpTimerStart	= 0.0; // Stores the value the timer started at since it speeds up relative to Hornoad's remaining HP.

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Hornoad, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Hornoad. It sets its sprite, creates an ambient light for its
/// eye, and sets it to be weak to all weaponry. It will set also randomly choose a starting direction.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_hornoad0, -1);
	object_add_light_component(x, y, 3, -6, 10, HEX_LIGHT_RED, 0.5);
	create_general_collider();
	initialize_weak_to_all();
	
	// Randomly choose a starting direction upon initialization.
	movement	 = choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	lightOffsetX = 4 * movement;
	image_xscale = movement;
}

#endregion

#region Hitstun function override

/// Stores the parent object's function for applying a hitstun effect onto an entity so it can be called in
/// this function definition that would overwrite the reference to the original otherwise.
___entity_apply_hitstun = entity_apply_hitstun;
/// @description A slight deviation from the standard hitstun function found in par_enemy; the parent of this
/// object. It will instantly set its jumping cooldown timer to the value is requires for making the Hornoad
/// execute its jump state once again, but only if it's higher than the "facing lock time" value.
/// @param {Real}	duration	Time in "frames" to apply the hitstun (Excluding the recovery) for (60 frames = 1 second).
/// @param {Real}	damage		Damage to deduct to the entity's current hitpoints.
entity_apply_hitstun = function(_duration, _damage){
	___entity_apply_hitstun(_duration, _damage);
	if (jumpTimer > HRND_FACING_LOCK_TIME)	{jumpTimer = HRND_JMP_COOLDOWN_TIME;}
	else									{jumpTimer += HRND_FACING_LOCK_TIME;} // Instantly flip to face Samus after being hit.
}

#endregion

#region State function initialization

/// @description The Hornoad's default state, which allows it to do two different things. The first is enter
/// into its jumping state should the value stored in "jumpTimer" exceed the required value, and the second
/// is the ability to change facing directions relative to which side of the Hornoad Samus is on.
state_default = function(){
	// Keep incrementing the jump timer until it exceeds the required amount, which will instantly switch the
	// Hornoad into its airbourne state.
	jumpTimer += DELTA_TIME;
	if (jumpTimer > HRND_JMP_COOLDOWN_TIME){
		object_set_next_state(state_airbourne);
		entity_set_sprite(spr_hornoad1, -1);
		stateFlags &= ~(1 << GROUNDED);
		hspd		= maxHspd * movement;
		vspd		= maxVspd;
		return;
	}
	
	// Wait until the "jumpTimer" variable surpasses the small buffer interval so the Hornoad can't instantly 
	// switch directions upon landing, which it would do without this check.
	if (jumpTimer - jumpTimerStart < HRND_FACING_LOCK_TIME) {return;}
	
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

/// @description The Hornoad's airbourne state, which is runs through whenever it is still in the air after a
/// jump has been executed. It will simply apply gravity's effect on the Hornoad before updaing its current
/// x and y position relative to its hspd and vspd values, respectively.
state_airbourne = function(){
	// Apply gravity's effect on the Hornoad for the frame, and then check to see if it has landed on the ground.
	apply_gravity(MAX_FALL_SPEED);
	if (IS_GROUNDED){ // Hit the ground; return to default state.
		object_set_next_state(state_default);
		entity_set_sprite(spr_hornoad0, -1);
		hspd = 0.0;
		vspd = 0.0;
		
		// Reset the jump timer, but start it above 0.0 relative to the amount of HP is has lost. This means
		// the hornoad will jump more frequently the less HP is has remaining.
		jumpTimer		= (1.0 - (hitpoints / maxHitpoints)) * (HRND_JMP_COOLDOWN_TIME - HRND_FACING_LOCK_TIME);
		jumpTimerStart	= jumpTimer; // Store starting time so it can't instantaneously switch facing directions.
		return;
	}
	
	// The Hornoad is still airbourne, so update its position for the frame.
	apply_frame_movement(entity_world_collision);
}

#endregion

// Set the Hornoad to its default state upon creation.
initialize(state_default);