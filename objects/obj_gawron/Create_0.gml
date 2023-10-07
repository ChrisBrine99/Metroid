#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	The amount of time in unit frames (60 == 1 second of real-time) that the Gawron must wait before it    //
//	can try charging toward Samus and how long it waits after reaching its target prior to charging.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GWRN_SPAWN_TIME			24.0
#macro	GWRN_WAIT_TIME			20.0

// ------------------------------------------------------------------------------------------------------- //
//	Determines the speed at which the Gawron will shake horizontally before it charges toward Samus.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	GWRN_SHIFT_INTERVAL		1.5

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Gawron will be able to 
// take two hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 2;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Gawron. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 8;
stunDuration	= 8;

#endregion

#region Unique variable initializations

// 
spawnTimer	= 0.0;
waitTimer	= 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Gawron, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Gawron. Determines the direction the Gawron will face towards
/// and move in alongside all other enemy initialization code.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_gawron, -1);
	create_general_collider();
	
	// 
	maxHspd	=  2.5;
	maxVspd = -1.4;
	
	// 
	hAccel	= 0.5;
	vAccel	= 0.1;
	
	// Set up weakness flags such that the Gawron is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Gawron is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 55;
	dropChances[ENMY_LGENERGY_DROP]		= 5;
	dropChances[ENMY_SMMISSILE_DROP]	= 20;
	dropChances[ENMY_LGMISSILE_DROP]	= 0;
	dropChances[ENMY_AEION_DROP]		= 0;
	dropChances[ENMY_POWBOMB_DROP]		= 5;
	
	// Determines the direction that Gawron faces, which is based on Samus's horizontal position relative to
	// its own. It will always face towards Samus unless she doesn't exist. In that case, the Gawron will
	// always move to the right.
	var _playerX = 0xFFFFFFFF;
	with(PLAYER) {_playerX = x;}
	image_xscale = (_playerX >= x) ? MOVE_DIR_RIGHT : MOVE_DIR_LEFT;
}

#endregion

#region State function initialization

/// @description The Gawron's "introduction" state, which causes it to rise upwards until its "spawnTimer"
/// variable is equal to the value stored in the macro GWRN_SPAWN_TIME and Samus's vertical position is equal
/// to or below the Gawron's own vertical position (That target y relative to Samus is dependant on if she's 
/// standing, crouching, or in her morphball form, so it's not a constant value).
state_intro = function(){
	// Accelerate vertically until the Gawron hits its maximum upward vertical velocity; giving it a brief
	// acceleration period instead of the Gawron spawning in a max speed.
	vspd -= vAccel;
	if (vspd < maxVspd) {vspd = maxVspd;}
	
	// Process movement for the frame since only vertical velocity matters at the moment. No collisions against
	// the world are checked for.
	apply_frame_movement(NO_FUNCTION);
	
	// Increment time since spawn until it reaches the required value. Once that occurs, the Gawron will be
	// able to charge at Samus should she be at or below the current target y position.
	spawnTimer += DELTA_TIME;
	if (spawnTimer < GWRN_SPAWN_TIME)
		return;

	// Calculate the target y position based on Samus's current y position and an offset that is applied to
	// ensure the target is at the center of the sprite that represents her currently on the screen.
	var _playerY = 0xFFFFFFFF;
	with(PLAYER){
		if (PLYR_IN_MORPHBALL)		{_playerY = y - 8;}
		else if (PLYR_IS_CROUCHED)	{_playerY = y - 14;}
		else						{_playerY = y - 24;}
	}
	
	// Don't shift to the next state if the target y position hasn't been met or surpassed.
	if (y > _playerY)
		return;
	
	// The target position was hit by Samus, the Gawron will instantly switch into its attacking states. The
	// first of those being the brief "beginning attack" state to let the player know the Gawron is about to
	// do something else.
	object_set_next_state(state_begin_attack);
	waitTimer	= GWRN_WAIT_TIME;
	vspd		= 0.0;
	shiftBaseX	= x;
}

/// @description A very simple state for the Gawron. It occurs before the Gawron actually charges towards Samus 
/// along the x axis and after Samus has hit the required target position for the Gawron to attack. All the
/// Gawron will do in this state is wait for a small amount of time doing nothing, shake back and forth 
/// horizontally until the "waitTimer" is passed half the required value, and then swap into the main attack
/// state after that required value is met.
state_begin_attack = function(){
	waitTimer -= DELTA_TIME;
	if (waitTimer <= 0.0){
		object_set_next_state(state_attack);
		x = shiftBaseX;
		return;
	}
	
	if (waitTimer < GWRN_WAIT_TIME * 0.5)
		apply_horizontal_shift(GWRN_SHIFT_INTERVAL);
}

/// @description Another very simple state for the Gawron. All it will do in this state is charge forward until
/// the Gawron is deleted by going off screen (This is done in the "Outside View 0" event).
state_attack = function(){
	// Accelerate along the horizontal axis until the Garwon reaches its maximum possible velocity on said axis.
	// The direction is dependant on the direction the Gawron is facing, which is either right (+1) or left (-1).
	hspd += hAccel * image_xscale;
	if (hspd > maxHspd || hspd < -maxHspd)
		hspd = maxHspd * image_xscale;
		
	// Just like the intro state, the Gawron will simply apply its horizontal velocity to its current position
	// and not process any collision with the world.
	apply_frame_movement(NO_FUNCTION);
}

#endregion

// Once the create event has executed, initialize the Gullug by setting it to its default state function.
initialize(state_intro);