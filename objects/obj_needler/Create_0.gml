#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum speed of the Needler (This also applies to its maximum vertical velocity since it only needs
// a single speed value while craling along surfaces and walls).
maxHspd			= 0.4;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Needler will be able to 
// take six hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 6;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Needler. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 12;
stunDuration	= 10;

#endregion

#region Initiaize function override

/// @description Initialize the Needler by setting its sprite, setting up the weaknesses it has to Samus's 
/// various methods of attacking, the drop chances for pickups, as well as its movement direction based on a 
/// 50/50 chance of left or right being chosen.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_needler, -1);
	
	// Set up weakness flags such that the Needler is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Needler is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 25;
	dropChances[ENMY_LGENERGY_DROP]		= 5;
	dropChances[ENMY_SMMISSILE_DROP]	= 25;
	dropChances[ENMY_LGMISSILE_DROP]	= 5;
	dropChances[ENMY_AEION_DROP]		= 10;
	dropChances[ENMY_POWBOMB_DROP]		= 5;
	
	// Determine the movement direction based on a 50/50 chance to move in either direction.
	movement = choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
}

#endregion

// Once the create event has executed, initialize the Needler by setting it to its default state function.
initialize(state_default);