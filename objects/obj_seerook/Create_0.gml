#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Determine the maximum horizontal velocity for the Seerook, as well as its horizontal acceleration so it 
// doesn't instantly snap to that maximum speed.
maxHspd = 1.2;
hAccel	= 0.2;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Yumbo will be able to take
// two hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints = 2;
hitpoints = maxHitpoints;

// Set the damage output and hitstun duration for the Ripper. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 6;
stunDuration	= 6;

#endregion

#region Unique variable initialization

// Variables that will store the x coordinates for the leftmost and rightmost x coordinates of the Seerook's
// path object (obj_seerook_collider).
pathStart	= 0;
pathEnd		= 0;

// Determines the direction that the Seerook is currently moving in; right or left.
movement	= 0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Seerook, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialize the Seerook by setting up its weaknesses, weapon collider bounding box, starting
/// sprite, drop rates, movement direction, and the starting/ending x coordinates for its movement path.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_seerook, -1);
	create_general_collider();
	
	// Set up weakness flags such that the Seerook is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Seerook is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 40;
	dropChances[ENMY_LGENERGY_DROP]		= 20;
	dropChances[ENMY_SMMISSILE_DROP]	= 10;
	dropChances[ENMY_LGMISSILE_DROP]	= 0;
	dropChances[ENMY_AEION_DROP]		= 20;
	dropChances[ENMY_POWBOMB_DROP]		= 0;
	
	// Randomly determine a starting direction: left (-1) or right (+1); flipping the Seerook's facing direction 
	// if the chosen starting direction is to the left.
	movement = choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	
	// Check for the Seerook's accompanying path object. If there wasn't one placed within its bounding box,
	// it will destroy itself since it won't know what path to follow.
	var _pathID = instance_place(x, y, obj_seerook_collider);
	if (_pathID == noone){
		instance_destroy(self);
		return;
	}
	
	// Store the collider's leftmost (The "Starting" value for the path) and leftmost bounds (The "Ending" 
	// value) into two variables that can be quickly referenced by the Seerook. After that, the path instance
	// is destroyed since it is no longer needed.
	pathStart	= _pathID.bbox_left;
	pathEnd		= _pathID.bbox_right;
	instance_destroy(_pathID);
}

#endregion

#region State function initialization

/// @description The Seerook's default and only state. It is very similar to the Ripper; with the only difference
///	being it doesn't reverse its horizontal direction because of colliding with a wall, but by exceeds the area
/// that it is allowed to move (Determines by the horizontal scaling of its "path" object).
state_default = function(){
	var _deltaTime = DELTA_TIME;
	hspd += movement * hAccel * _deltaTime;		// Update horizontal velocity.
	if (hspd > maxHspd || hspd < -maxHspd) 
		hspd = maxHspd * movement;
	
	var _deltaHspd	= hspd * _deltaTime;		// Remove decimal values from velocity.
	var _signHspd	= sign(_deltaHspd);
	_deltaHspd	   += hspdFraction;
	hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * _signHspd);
	_deltaHspd	   -= hspdFraction;
	x			   += _deltaHspd;				// Add whole number value to the Seerook's X position.
	
	// Check if the Seerook has reached the end of its path relative to its current movement direction. If the
	// bounds have been reached or exceeded, the Seerook will reverse its horizontal direction.
	if (movement == MOVE_DIR_RIGHT && x >= pathEnd){
		movement    = MOVE_DIR_LEFT;
		x			= pathEnd;
	} else if (movement == MOVE_DIR_LEFT && x <= pathStart){
		movement	= MOVE_DIR_RIGHT;
		x			= pathStart;
	}
}

#endregion

// Once the create event has executed, initialize the Seerook by setting it to its default state function.
initialize(state_default);