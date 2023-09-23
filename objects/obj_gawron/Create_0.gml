#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	The amount of time in unit frames (60 == 1 second of real-time) that the Gawron waits after reaching   //
//	its target position (20 pixels above Samus's true position) prior to charging towards her.			   //
// ------------------------------------------------------------------------------------------------------- //

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

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.25;	// 25%
aeionDropChance		= 0.25;	// 25%
ammoDropChance		= 0.25;	// 25%

#endregion

#region Unique variable initializations

// 
waitTimer = 0.0;

#endregion

#region Initialize function override

/// Store the pointer for the parent's initialize function into a local variable for the Gawron, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Gawron.
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
	vAccel	= 0.2;
	
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
	
	// 
	var _playerX = 0;
	with(PLAYER) {_playerX = x;}
	image_xscale = (_playerX >= x) ? MOVE_DIR_RIGHT : MOVE_DIR_LEFT;
}

#endregion

#region State function initialization

/// @description 
state_intro = function(){
	// 
	vspd -= vAccel;
	if (vspd < maxVspd) {vspd = maxVspd;}
	
	// 
	var _playerX = 0;
	var _playerY = 0;
	with(PLAYER){
		_playerX = x;
		_playerY = y - 24;
	}
	
	// 
	if (y <= _playerY && !collision_line(x, y, _playerX, y, par_collider, false, true)){
		object_set_next_state(state_begin_attack);
		waitTimer	= GWRN_WAIT_TIME;
		vspd		= 0.0;
		shiftBaseX	= x;
		return;
	}
	
	// 
	apply_frame_movement(NO_FUNCTION);
}

/// @description 
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

/// @description 
state_attack = function(){
	// 
	hspd += hAccel * image_xscale;
	if (hspd > maxHspd || hspd < -maxHspd)
		hspd = maxHspd * image_xscale;
		
	// 
	apply_frame_movement(NO_FUNCTION);
}

#endregion

// Once the create event has executed, initialize the Gullug by setting it to its default state function.
initialize(state_intro);