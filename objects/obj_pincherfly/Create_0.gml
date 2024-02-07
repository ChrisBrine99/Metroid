#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Stores the radius that the player must be within relative to the Pincherfly's position in order for    //
//	it to attempt to attack them.																		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PFLY_ATTACK_DISTANCE	64.0

// ------------------------------------------------------------------------------------------------------- //
//	Macros that stores intervals of time that apply to various parts of the Pincherfly. In this case, the  //
//	time necessary to wait before attacking and the time required before it updates its position while in  //
//	its dormant state (60 units roughly equals 1 real-world second).									   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PFLY_ATK_COOLDOWN_TIME	65.0

// ------------------------------------------------------------------------------------------------------- //
//
// ------------------------------------------------------------------------------------------------------- //

#macro	PFLY_MAXHSPD_DORMANT	0.5
#macro	PFLY_MAXVSPD_DORMANT	0.9
#macro	PFLY_DIRECTION_INTERVAL	20.0
#macro	PFLY_DIRECTION_OFFSET	90.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Determines how maximum possible speed the Pincherfly can move at towards and away from Samus when it 
// attempts to attack her (These values are altered relative to the angle between the Pincherfly's and Samus's
// position at the beginning of the attack).
maxHspd			= 2.5;
maxVspd			= 2.5;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Pincherfly will be able 
// to take a single hit before dying; regardless of the weapon used
maxHitpoints	= 1;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Pincherfly. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 4;
stunDuration	= 6;

#endregion

#region Unique variable initialization

// Stores the start position for the Pincherfly's current path of movement relative to the current state it
// is in. While dormant, it's used as the origin point for its sporadic flying. While attacking, it stores
// where it began moving in order to calculate the distance it has traveled while attacking and returning to
// the air after attacking.
startX			= x;
startY			= y;

// Stores The Pincherfly's y position at the time of creation and doesn't change from that value. Used to allow
// it to return back to around that y position after returning from attacking Samus.
initialY		= y;

// Stores how far the Pincherfly must travel in order to hit Samus. Once it reaches or surpasses this amount,
// it will fly back up into the air and wait briefly before it can swoop down at Samus once again.
targetDistance	= 0.0;

// Stores a value above zero whenever the Pincherfly has been set to wait before it can try to attack the 
// player again. There is no cooldown on when it can attack for the first time since the default timer value
// is zero.
cooldownTimer	= 0.0;

// Two variables that determine how the Pincherfly moves while dormant. The first stores the current "direction"
// it is moving in relative to which half of its figure-8 pattern it is currently moving along, and the second
// simply determines if the starting movement direction is to the right or left.
moveDirection	= 0.0;
movement		= 1;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Gawron, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Pincherfly.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_pincherfly, -1);
	object_add_light_component(x, y, 0, -1, 24, HEX_LIGHT_RED, 0.5);
	create_weapon_collider(-7, -4, 14, 8, false);
	
	// Set up weakness flags such that the Pincherfly is weak to every type of weapon Samus can utilize.
	weaknessFlags  |= (
		// --- Beam Type Flags --- //
		ENMY_POWBEAM_WEAK | ENMY_ICEBEAM_WEAK | ENMY_WAVBEAM_WEAK | ENMY_PLSBEAM_WEAK | ENMY_CHRBEAM_WEAK |
		// --- Missile Flags --- //
		ENMY_REGMISSILE_WEAK | ENMY_SUPMISSILE_WEAK | ENMY_ICEMISSILE_WEAK | ENMY_SHKMISSILE_WEAK |
		// --- Bomb/Screw Attack Flags --- //
		ENMY_REGBOMB_WEAK | ENMY_POWBOMB_WEAK | ENMY_SCREWATK_WEAK |
		// --- Ailment Flags --- //
		ENMY_STUN_WEAK | ENMY_SHOCK_WEAK | ENMY_FREEZE_WEAK
	);
	
	// Set the rates for item drops if the Pincherfly is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 20;
	dropChances[ENMY_LGENERGY_DROP]		= 10;
	dropChances[ENMY_SMMISSILE_DROP]	= 20;
	dropChances[ENMY_LGMISSILE_DROP]	= 10;
	dropChances[ENMY_AEION_DROP]		= 20;
	dropChances[ENMY_POWBOMB_DROP]		= 10;
	
	// Do a "coin flip" to determine the direction of the Pincherfly's dormant movement.
	movement = choose(MOVE_DIR_RIGHT, MOVE_DIR_LEFT);
}

#endregion

#region State function initialization

/// @description The Pincherfly's default/dormant state. If Samus enters its attack radius, the Pincherfly will 
///	set up its horizontal and vertical velocities in order to charge towards Samus.
state_default = function(){
	// Instead of utilizing GameMaker's built-in direction variable, a unique variable is used to achieve the
	// same thing while also allowing a shift to occur for every full circle the value makes. This wouldn't be
	// possible with the built-in variable.
	moveDirection += PFLY_DIRECTION_INTERVAL * DELTA_TIME;
	if (moveDirection >= FULL_CIRCLE){
		moveDirection -= FULL_CIRCLE;
		movement	  *= -1;
	}
	
	// Move the Picherfly along its figure-8 pattern relative to the current movement direction and movement
	// sign (+1 moves the Pincherfly to the right, -1 moves it to the left). The direction is offset by 90
	// degrees to make the figure-8 horizontal instead of vertical.
	var _direction = moveDirection - PFLY_DIRECTION_OFFSET;
	hspd = lengthdir_x(PFLY_MAXHSPD_DORMANT, _direction) * movement;
	vspd = lengthdir_y(PFLY_MAXVSPD_DORMANT, _direction); // Multiplication against "movement" not required.
	apply_frame_movement(NO_FUNCTION);
	
	// Decrement the cooldown timer if it is ever above a value of zero. No other code in this state will be
	// executed until this condition has been met.
	if (cooldownTimer > 0.0){
		cooldownTimer -= DELTA_TIME;
		return;
	}
	
	// Check is Samus is close enough for the Pincherfly to attack her. If not, no other code in this state
	// will be executed.
	if (distance_to_object(PLAYER) > PFLY_ATTACK_DISTANCE)
		return;
	
	// Grab the player's current position so the direction that the Pincherfly must move toward can be found.
	// The y position value is offset by different amounts based on if Samus is crouching, standing, or in her
	// morphball form.
	var _playerX = 0;
	var _playerY = 0;
	with(PLAYER){
		_playerX = x;
		
		// Determine proper y position offset based on Samus's current state flags.
		if (PLYR_IN_MORPHBALL)		{_playerY = y - 8;}
		else if (PLYR_IS_CROUCHED)	{_playerY = y - 12;}
		else						{_playerY = y - 16;}
	}
	
	// Caluclate the angle between Samus's current position and the Pincherfly's current position. Then, the
	// velocity for the Pincherfly along both axes is determined based on the resulting angle.
	direction = point_direction(x, y, _playerX, _playerY);
	hspd = lengthdir_x(maxHspd, direction);
	vspd = lengthdir_y(maxVspd, direction);
	
	// Set the Pincherfly to enter into its attacking state on the next frame. Store the position it began the
	// attack at, and determine how far it needs to travel to reach Samus's position. Speed up its animation
	// speed as well.
	object_set_next_state(state_attack);
	startX			= x;
	startY			= y;
	travelDistance	= point_distance(x, y, _playerX, _playerY);
	animSpeed		= 1.8;
}

/// @description The Pincherfly's main attacking state, which simply moves it along the path it calculated
/// right before it entered the state. If the distance it has traveled in this state exceeds what was determined
/// and stored into "travelDistance", the Pincherfly will end its attack and return to the air once again.
state_attack = function(){
	// Calculate movement based on delta time for the current frame and check the distance traveled for the
	// frame as well. If the distance is too small no other code in the state will be executed.
	apply_frame_movement(NO_FUNCTION);
	if (point_distance(x, y, startX, startY) < travelDistance)
		return;
		
	// Determine an angle that will cause the Pincherfly to move back into the air relatively close to where
	// it hit Samus. The horizontal and vertical velocities are calculated based on the resulting direction
	// value.
	direction = 90.0 - (random_range(5.0, 25.0) * sign(hspd));
	hspd = lengthdir_x(maxHspd, direction);
	vspd = lengthdir_y(maxVspd, direction);
	
	// Finally, the Pincherfly will be moved onto its ending attack state. The target Y position is stored in
	// the "startY" variable and the Pincherfly's animation speed is returned back to its initial value.
	object_set_next_state(state_end_attack);
	startY			= initialY + irandom_range(-8, 8);
	animSpeed		= 1.0;
}

/// @description A very simple function that checks the Pincherfly's y position after moving for the current
/// frame. If it ends up at or above the target position (Stored in "startY"), it will be snapped to that
/// values before being returned back to its dormant state.
state_end_attack = function(){
	apply_frame_movement(NO_FUNCTION);
	if (y <= startY){
		object_set_next_state(state_default);
		y				= startY; // Snap to target before overwriting variable's contents.
		cooldownTimer	= PFLY_ATK_COOLDOWN_TIME;
		moveDirection	= 0.0;
		movement		= choose(MOVE_DIR_RIGHT, MOVE_DIR_LEFT);
		startX			= x;
		startY			= y;
	}
}

#endregion

// Once the create event has executed, initialize the Pincherfly by setting it to its default state function.
initialize(state_default);