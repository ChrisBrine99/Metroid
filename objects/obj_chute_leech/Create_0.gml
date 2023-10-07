#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Macros that store the values for the Chute Leech's vertical gravity modifier relative to its actual    //
//	falling speed (Used when floating down to the ground) and the overall strength of its jumping.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	CLCH_VACCEL_FALL_MOD	0.5
#macro	CLCH_JUMP_STRENGTH	   -7.8

// ------------------------------------------------------------------------------------------------------- //
//	The range of time in "frames" (60 of those "frames" being one real-world second) that the Chute Leech  //
//	will wait before it jumps into the air.																   //
// ------------------------------------------------------------------------------------------------------- //

#macro	CLCH_WAIT_MIN_TIME		75.0
#macro	CLCH_WAIT_MAX_TIME		170.0

// ------------------------------------------------------------------------------------------------------- //
//	Determines how the Chute Leech will float back to the ground after reaching the apex of its jump. The  //
//	first value is the base time in "frames" it takes for the Chute Leech to switch the direction it's     //
//	currently floating in (This value is halved for the very first "sway" in the float), and the second    //
//	value is how much is added to that minimum swaying time relative to how many times the Chute Leech has //
//	changed direction while doing so; making each subsequent one longer than the last by a small portion.  //
// ------------------------------------------------------------------------------------------------------- //

#macro	CLCH_MIN_SWAY_TIME		30.0
#macro	CLCH_SWAY_TIME_MOD		10.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Chute Leech will be able 
// to take four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Chute Leech. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 12;
stunDuration	= 10;

#endregion

#region Unique variable initializations

// Stores the vertical position that represents the Chute Leech's "home" or default value. It will immediately
// stop floating down once its current y position reaches or exceeds the value found stored here. Otherwise,
// it will keep falling; even through walls/floors/ceilings.
jumpStartY	 = 0;

// Determines characteristics regarding the Chute Leech's floating state, which occurs directionly after it
// reaches the apex of its jump. The first value stores the direction it started swaying toward during its last
// jump; to prevent it from being truly random. The second simply increments for each time the Leech changes
// direction, which helps detemine how long this direction of movement will last.
lastStartDir = 0;
numSways	 = 0;

// A simple timer variable that is used to determine when the Chute Leech can jump relative to the time it needs
// to wait for after landing, and for waiting to changing swaying direction as it floats back to the ground.
waitTimer = 0.0;

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
	entity_set_sprite(spr_chute_leech0, -1);
	create_general_collider();
	
	// Set the maximum horizontal movement velocity and maximum falling speed here (The jump height is a negative
	// value so it isn't stored as a maximum to avoid potential issues/confusion with code's logic).
	maxHspd = 2.0;
	maxVspd = 0.8;
	
	// Also set the horizontal and vertical accelerations for the Chute Leech. The latter value being used to
	// determine the strength of gravity on it as it is airbourne.
	hAccel = 0.1;
	vAccel = 0.25;
	
	// Set up weakness flags such that the Chute Leech is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Chute Leech is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 35;
	dropChances[ENMY_LGENERGY_DROP]		= 10;
	dropChances[ENMY_SMMISSILE_DROP]	= 25;
	dropChances[ENMY_LGMISSILE_DROP]	= 8;
	dropChances[ENMY_AEION_DROP]		= 10;
	dropChances[ENMY_POWBOMB_DROP]		= 2;
	
	// Immediately store the initial Y position of the Chute Leech so it knows where "home" is after jumping.
	// Also, randomly set a previous starting direction so each Chute Leech has a 50/50 chance of starting by
	// going right or left. Finally, set it to wait for the minimum amount of time before jumping.
	jumpStartY		= y;
	lastStartDir	= choose(MOVE_DIR_RIGHT, MOVE_DIR_LEFT);
	waitTimer		= CLCH_WAIT_MIN_TIME;
}

#endregion

#region State function initialization

/// @description The default state for the Chute Leech. All that happens during this state is the Chute Leech
/// decrements the value currently stored in its "waitTimer" variable. Once that value reaches zero, it will
/// jump into the air, which is handled in the next state.
state_default = function(){
	waitTimer -= DELTA_TIME;
	if (waitTimer < 0.0){
		object_set_next_state(state_jump_start);
		entity_set_sprite(spr_chute_leech1, -1);
		vspd = CLCH_JUMP_STRENGTH;
	}
}

/// @description The first part of the Chute Leech's jump, which has it simply shooting directly upwards until
/// it hits a vertical velocity grater than zero. At that point, it will move onto the second stage of its
/// jumping code to gently float to the ground.
state_jump_start = function(){
	// Increment the current vertical velocity until it surpasses a value of zero. When that happens, the Chute
	// Leech will be at its jump's apex and should switch to the second jumping state.
	vspd += vAccel * DELTA_TIME;
	if (vspd > 0.0){
		object_set_next_state(state_jump_end);
		entity_set_sprite(spr_chute_leech2, -1);
		vspd			= 0.0;
		waitTimer		= CLCH_MIN_SWAY_TIME / 2.0;	// <- Value is halved since Chute leech is in the "middle"
		image_xscale	= lastStartDir;				//	  of the region where it will sway back and forth.
		return;
	}
	
	// No horizontal movement occurs in this state, so the Chute Leech's position is updated immediately after
	// its current vertical velocity has been set. It doesn't collide with the world in any normal capacity.
	apply_frame_movement(NO_FUNCTION);
}

/// @description The final state for the Chute Leech and the second of the two jumping states. When in this
/// state, the Chute Leech will move horizontally and vertically until it reaches or goes below its "starting"
/// y position. Once that happens, the Chute Leech is returned to its default state so it can wait before
/// jumping again and repeating the process.
state_jump_end = function(){
	// Store current delta time in a local variable so it doesn't need to be retrieved multiple times through
	// the state's code, which very, very, VERY slightly speeds up the code's execution.
	var _deltaTime = DELTA_TIME;
	
	// Utilize the "waitTimer" variable to decrement the current "sway" time until it goes below zero. After
	// that point, the Chute Leech will slow down along both axes; switching movement direction along the x
	// axis once reaching a complete stop on said axis.
	waitTimer -= _deltaTime;
	if (waitTimer < 0.0){
		// Decelerate until the Chute Leech is no longer moving to the left or right. Once that happens, the
		// hspd and vspd values are cleared to zero and the movement direction is flipped by multiplying its
		// current "image_xscale" [Right (+1) and Left (-1)] by -1.
		hspd -= hAccel * image_xscale * _deltaTime;
		if (hspd < hAccel || hspd > -hAccel){
			waitTimer		= CLCH_MIN_SWAY_TIME + (CLCH_SWAY_TIME_MOD * numSways);
			hspd			= 0.0;
			vspd			= 0.0;
			image_xscale   *= -1;
			numSways++;
			return; // Vspd is already 0.0; don't both with code below.
		}
		
		// Slowly set the Chute Leech to a vertical velocity of 0.0 so it float for a bit before changing
		// the direction it's currently swaying in.
		vspd -= vAccel * CLCH_VACCEL_FALL_MOD * DELTA_TIME;
		if (vspd < 0.0) {vspd = 0.0;}
		return;
	}
	
	// Accelerate the Chute Leech until it reaches its maximum possible horizontal velocity relative to its
	// current direction of movement, which is determined by the value stored in "image_xscale".
	hspd += hAccel * image_xscale * _deltaTime;
	if (hspd < -maxHspd || hspd > maxHspd)
		hspd = maxHspd * image_xscale;
		
	// Apply gravity to the Chute Leech, but lower its strength by 50% so it doesn't fall as fast as it should,
	// which helps to sell the fact that it should be gently floating down to the ground.
	vspd += vAccel * CLCH_VACCEL_FALL_MOD * DELTA_TIME;
	if (vspd > maxVspd)
		vspd = maxVspd;
		
	// Perform the same position updating function call as the first jumping state, but check if the Chute Leech
	// is back on the ground where it started on top of updating its position. Once it is below its "home" y
	// position AND there's actually a floor underneath it, the Chute Leech will be snapped back to that y
	// position and it will be reset to wait before jumping again.
	apply_frame_movement(NO_FUNCTION);
	if (y >= jumpStartY && place_meeting(x, y + 1, par_collider)){
		object_set_next_state(state_default);
		entity_set_sprite(spr_chute_leech0, -1);
		y				= jumpStartY;
		hspd			= 0.0;
		vspd			= 0.0;
		waitTimer		= random_range(CLCH_WAIT_MIN_TIME, CLCH_WAIT_MAX_TIME);
		lastStartDir   *= -1;
		numSways		= 0;
	}
}

#endregion

// Once the create event has executed, initialize the Chute Leech by setting it to its default state function.
initialize(state_default);