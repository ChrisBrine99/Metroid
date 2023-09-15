#region Macro initialization

// 
#macro	HRND_ALERTED			0x00000001
#macro	HRND_FLIP_DIRECTION		0x00000002

// 
#macro	HRND_IS_ALERTED			(stateFlags & HRND_ALERTED)
#macro	HRND_CAN_FLIP_DIRECTION	(stateFlags & HRND_FLIP_DIRECTION)

// 
#macro	HRND_ALERT_RADIUS		56.0

// 
#macro	HRND_DEFAULT_HSPD		1.0
#macro	HRND_DEFAULT_VSPD	   -2.5
#macro	HRND_ALERTED_HSPD		1.8
#macro	HRND_ALERTED_VSPD	   -4.0
#macro	HRND_MAX_FALL_SPEED		8.0

// 
#macro	HRND_JMP_COOLDOWN_TIME	100.0
#macro	HRND_FACING_LOCK_TIME	25.0

// 
#macro	HRND_CD_REDUCTION		40.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// 
maxHspd = HRND_ALERTED_HSPD;
maxVspd = HRND_ALERTED_VSPD;

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
jumpTimer = 0.0;

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
	//object_add_light_component(x, y, 3, -4, 10, HEX_LIGHT_RED, 0.5);
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
/// object. It will reduce the time required for the Hornoad to jump again and instantly put the Hornoad in its
/// alerted substate.
/// @param {Real}	duration	Time in "frames" to apply the hitstun (Excluding the recovery) for (60 frames = 1 second).
/// @param {Real}	damage		Damage to deduct to the entity's current hitpoints.
entity_apply_hitstun = function(_duration, _damage){
	___entity_apply_hitstun(_duration, _damage);
	stateFlags	|= HRND_ALERTED;
	jumpTimer	+= HRND_CD_REDUCTION;
	
	// Ignore snapping facing direction to which side the projectile hit the Hornoad on if they're already
	// in the air, as turning around while airbourne looks weird.
	if (!IS_GROUNDED) {return;}
	
	// Instantly snap the Hornoad to face the direction of the projectile that hit it, which should also be
	// the direction that Samus is in relative to the Hornoad's position.
	var _playerX = PLAYER.x;
	if ((_playerX < x && movement == MOVE_DIR_RIGHT) || (_playerX >= x && movement == MOVE_DIR_LEFT)){
		movement	 *= -1;
		image_xscale *= -1;
		lightOffsetX *= -1;
	}
}

#endregion

#region State function initialization

/// @description The Hornoad's default state, which allows it to do two different things. The first is enter
/// into its jumping state should the value stored in "jumpTimer" exceed the required value, and the second
/// is the ability to change facing directions relative to which side of the Hornoad Samus is on.
state_default = function(){
	// Check that prevents accidental execution of this function if the Hornoard is hit by one of Samus's
	// weapons before its state function happens to be executed.
	if (ENTT_IS_HIT_STUNNED) {return;}
	
	// Keep incrementing the jump timer until it exceeds the required amount, which will instantly switch the
	// Hornoad into its airbourne state. Depending on the situation, the Hornoad can be prevented from jumping
	// and instead flip directions and reset its jump cooldown timer.
	jumpTimer += DELTA_TIME;
	if (jumpTimer > HRND_JMP_COOLDOWN_TIME){
		// Perform a collision check against the top-left/top-right of the Hornoad (This check is relative to
		// whatever direction it is facing at the time of the jump attempt). If there is a collision at this
		// spot, the Hornoad won't attempt to jump; flipping its facing direction to try jumping again.
		if (place_meeting(x + (16 * movement), y - 16, par_collider)){
			stateFlags	 &= ~HRND_ALERTED;
			jumpTimer	  = 0.0;
			movement	 *= -1;
			image_xscale *= -1;
			lightOffsetX *= -1;
			return;
		}
		
		// If the collision check failed, the Hornoad is able to jump, so the proper state is applied to them
		// and the proper sprite is set. Its resulting jump velocity is determined below.
		object_set_next_state(state_airbourne);
		entity_set_sprite(spr_hornoad1, -1);
		stateFlags &= ~DNTT_GROUNDED;
		jumpTimer	= 0.0;
		
		// The hornoad will jump higher and further when altered, and will perform small hops when in its
		// docile state. This check determines which of the two outcomes for hspd/vspd executed.
		if (HRND_IS_ALERTED){
			stateFlags &= ~HRND_ALERTED;
			hspd		= HRND_ALERTED_HSPD * movement;
			vspd		= HRND_ALERTED_VSPD;
			return; // State changed and hspd/vspd already set; exit very early.
		}
		hspd = HRND_DEFAULT_HSPD * movement;
		vspd = HRND_DEFAULT_VSPD;
		return; // State changed; exit early.
	}
	
	// Logic that is only ran while the Hornoad isn't alerted to Samus's presence/hostility. During this
	// substate, a check to see if Samus gets too close to the Hornoad is performed; alerted the Hornoad if
	// said distance is too small.
	if (!HRND_IS_ALERTED){
		// First, get and store Samus's current position within the room. The values are defaulted to the
		// maximum possible values that a 32-bit integer can store if the player's coordinates could not be
		// retrieved for whatever reason.
		var _playerX = 0xFFFFFFFF;
		var _playerY = 0xFFFFFFFF;
		with(PLAYER){
			_playerX = x;
			_playerY = y;
		}
		
		// Perform the check against the Hornoad's current position and Samus's. If the length of the vector
		// calcualted is smaller than the Hornoad's alert radius, it will become alerted; facing her and having
		// its jumping capabilities increased.
		if (point_distance(x, y, _playerX, _playerY) <= HRND_ALERT_RADIUS){
			stateFlags |= HRND_ALERTED;
			return; // Don't bother checking for docile direction changing once alerted.
		}
		
		// Have a bit of buffer time between the Hornoad landing and it being able to swap its direction.
		if (!HRND_CAN_FLIP_DIRECTION || jumpTimer < HRND_FACING_LOCK_TIME) 
			return;
		stateFlags &= ~HRND_FLIP_DIRECTION; // Ensures the below code is only ran once.
		
		// Choose a random direction between left (-1) and right (+1) and compare it against the current 
		// direction that the Hornoad is already facing. If they differ, the hornoad will flip to face the
		// other direction. Otherwise, it will remain facing the same direction.
		var _movement = choose(-1, 1);
		if (_movement != movement){
			movement	 *= -1;
			image_xscale *= -1;
			lightOffsetX *= -1;
		}
		return;
	}
	
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
	apply_gravity(HRND_MAX_FALL_SPEED);
	if (DNTT_IS_GROUNDED){ // Hit the ground; return to default state.
		object_set_next_state(state_default);
		entity_set_sprite(spr_hornoad0, -1);
		stateFlags |= HRND_FLIP_DIRECTION;
		hspd		= 0.0;
		vspd		= 0.0;
		return;
	}
	
	// The Hornoad is still airbourne, so update its position for the frame.
	apply_frame_movement(entity_world_collision);
}

#endregion

// Set the Hornoad to its default state upon creation.
initialize(state_default);