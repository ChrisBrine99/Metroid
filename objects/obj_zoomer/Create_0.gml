#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Since all crawling enemies have the ability to fall to the ground if they can't find a surface to attach
// themselves to, the values for gravity's strength (vAccel) and their terminal velocity are set here.
vAccel			= 0.25;
maxVspd			= 4.0;

#endregion

#region Unique variable initialization

// Determines the direction that the Zoomer is currently moving in; right or left.
movement = 0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Zoomer, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialize the Zoomer by setting its sprite, creating a custom weapon collision collider, 
/// setting up the weaknesses it has to Samus's various methods of attacking, the drop chances for pickups, as
/// well as its movement direction based on a 50/50 chance of left or right being chosen.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_zoomer, -1);
	create_weapon_collider(-8, -9, 14, 15, false);
	
	// Setting the Zoomer's maximum horizontal velocity within its state event since it's a parent object to
	// other crawling enemies (Hitpoints and damage values are also set here). This determines how fast the
	// Zoomer crawling along a given surface relative to its current movement direction.
	maxHspd			= 0.6;
	
	// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Zoomer will be able to 
	// take three hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
	maxHitpoints	= 3;
	hitpoints		= maxHitpoints;
	
	// Set the damage output and hitstun duration for the Zoomer. These values are increased/decreased by the
	// difficulty level selected by the player.
	damage			= 8;
	stunDuration	= 8.0;
	
	// Set up weakness flags such that the Zoomer is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Zoomer is defeated by Samus here.
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

#region Utility function initialization

/// @description Returns either a -1, 0, or 1 based on the directional value supplied to the function. It is
/// assumed only 8 directions are being considered (0, 45, 90, 135, 180, 225, 270, 315, and any overlapping
/// values above 360 and below 0), so the function defaults to 0 with values that don't meet those criteria.
/// @param {Real}	direction	Value that is considered when determining the returned value.
get_next_x_position = function(_direction){
	switch(_direction){
		default:
			return 0;
		case DIRECTION_EAST:
		case DIRECTION_NORTHEAST:
		case DIRECTION_SOUTHEAST:
		case DIRECTION_EAST + 360.0:
		case DIRECTION_EAST - 45.0:
			return 1;
		case DIRECTION_NORTHWEST:
		case DIRECTION_WEST:
		case DIRECTION_SOUTHWEST:
			return -1;
	}
}

/// @description Returns either a -1, 0, or 1 based on the directional value supplied to the function. It is
/// assumed only 8 directions are being considered (0, 45, 90, 135, 180, 225, 270, 315, and any overlapping
/// values above 360 and below 0), so the function defaults to 0 with values that don't meet those criteria.
/// @param {Real}	direction	Value that is considered when determining the returned value.
get_next_y_position = function(_direction){
	switch(_direction){
		default:		
			return 0;
		case DIRECTION_NORTHEAST:
		case DIRECTION_NORTH:
		case DIRECTION_NORTHWEST:
		case DIRECTION_NORTHEAST + 360.0:
		case DIRECTION_NORTH	 + 360.0:
			return -1;
		case DIRECTION_SOUTHWEST:
		case DIRECTION_SOUTH:
		case DIRECTION_SOUTHEAST:
		case DIRECTION_EAST - 45.0:
		case DIRECTION_EAST - 90.0:
			return 1;
	}
}

#endregion

#region State function initialization

/// @description The Zoomer's default state, which contains all of its movement and collision logic due to both
/// being heavily intertwined with each other. Much like the standard entity collision system, it works on a
/// pixel-perfect system that moves pixel-by-pixel for collisions. The main difference is the Zoomer moves
/// pixel-by-pixel regardless of if there is a collision or not in order to properly move along walls
/// regardless of their shape.
state_default = function(){
	// Update the stored fractional value by adding whatever has been stored previously with a new fractional
	// value that could be within "_deltaMove" after the frame's current delta time value is applied. What
	// remains in "_deltaMove" is a whole value to determine how many times the Zoomer should move in the frame.
	var _deltaMove  = maxHspd * DELTA_TIME;
	_deltaMove	   += hspdFraction;
	hspdFraction	= _deltaMove - (floor(abs(_deltaMove)) * sign(_deltaMove));
	_deltaMove	   -= hspdFraction;

	// Repeat this section of code for however many pixels the Zoomer should move based on the current value
	// of "_deltaMove" after the fractional value is removed. It will move the Zoomer pixel-by-pixel along the
	// path it needs to take; updating its direction after every pixel movement according to the shape of the 
	// collider(s) it is moving along.
	var _below = 0.0;
	var _nextX = 0;
	var _nextY = 0;
	repeat(_deltaMove){
		// A check is performed to see if there is no longer a floor exactly one pixel in front and one pixel
		// below the Zoomer. If that is the case, its direction is shifted 45 degress downward to allow it to
		// move down the potential slope it has found.
		_below = direction - (45.0 * movement);
		_nextX = get_next_x_position(_below);
		_nextY = get_next_y_position(_below);
		if (!place_meeting(x + _nextX, y + _nextY, par_collider)){
			direction = _below;
			
			// Perform another check 45 degrees below where the Zoomer is now facing. If there still isn't a
			// floor below, the Zoomer will shift yet another 45 degress down as there wasn't a slope under it,
			// but a hard corner instead.
			_below = direction - (45.0 * movement);
			_nextX = get_next_x_position(_below);
			_nextY = get_next_y_position(_below);
			if (!place_meeting(x + _nextX, y + _nextY, par_collider)){
				direction = _below;
			
				// After moving a full 90 degrees, a final check is performed to see if there is still a floor
				// beneath the Zoomer. If there is no floor found, the Zoomer is swapped to its falling state.
				_below = direction - (90.0 * movement);
				_nextX = get_next_x_position(_below);
				_nextY = get_next_y_position(_below);
				if (!place_meeting(x + _nextX, y + _nextY, par_collider)){
					object_set_next_state(state_falling);
					stateFlags  &= ~DNTT_GROUNDED;
					direction	 = (movement == MOVE_DIR_RIGHT) ? DIRECTION_EAST : DIRECTION_WEST;
					return;
				}
			}
		}
		
		// Checking for slopes that move upward relative to the zoomer's current movement direction. It checks 
		// in front of the Zoomer, and will shift its movement 45 degrees upward if there is an obstruction.
		_nextX = get_next_x_position(direction);
		_nextY = get_next_y_position(direction);
		if (place_meeting(x + _nextX, y + _nextY, par_collider)){
			direction += (45.0 * movement);
			
			// After moving 45 degrees, another check is performed to see if there is yet another obstruction.
			// If there is, a wall is in front of the Zoomer instead of a slope, so the direction is updated
			// by another 45 degrees to complete the full 90 degree shift in direction.
			_nextX = get_next_x_position(direction);
			_nextY = get_next_y_position(direction);
			if (place_meeting(x + _nextX, y + _nextY, par_collider))
				direction += (45.0 * movement);
		}
		
		// If the Zoomer is moving along a slope, the velocity needs to be limited to a value of 0.7071, which
		// is nearly equivalent to the length of the hypotenuse of the unit circle at 45, 135, 225, and 315
		// degrees. This causes the Zoomer to maintain its speed despite moving along two axes instead of a
		// single direction; as is the case with cardinal directions 0, 90, 180, and 270.
		if (direction == DIRECTION_NORTHEAST || direction == DIRECTION_NORTHWEST 
				|| direction == DIRECTION_SOUTHWEST || direction == DIRECTION_SOUTHEAST){
			// The variable "vspdFraction" stores fractional values for the movement to prevent any sub-pixel
			// movement while travelling along slopes.
			_deltaMove		= 0.7071;
			_deltaMove	   += vspdFraction;
			vspdFraction	= _deltaMove - (floor(abs(_deltaMove)) * sign(_deltaMove));
			_deltaMove	   -= vspdFraction;
			
			if (_deltaMove != 0){ // Only bother updating position if a whole number is found in "_deltaMove".
				x += _deltaMove * get_next_x_position(direction);
				y += _deltaMove * get_next_y_position(direction);
			}
			continue;
		}
		
		// The Zoomer is moving in one of the four cardinal directions, so it will simply add a -1, 0, or 1 to
		// both axes relative to which direction they're moving in.
		x += get_next_x_position(direction);
		y += get_next_y_position(direction);
	}
}

/// @description A simple state that has the Zoomer falling until it comes into contant with a floor. After
/// hitting a floor it will be set back to its default state and begin crawling along that surface instead of
/// wherever it had fell from.
state_falling = function(){
	// Applying gravity for the current frame.
	apply_gravity(maxVspd);
	if (DNTT_IS_GROUNDED){
		object_set_next_state(state_default);
		vspd		 = 0.0;
		vspdFraction = 0.0;
		return;
	}
	
	// Removing fractional values from the Zoomer's vspd value; storing those fractional values into a buffer
	// variable until a whole number can be parsed out of that variable.
	var _signVspd	= sign(vspd);
	var _deltaVspd	= vspd * DELTA_TIME;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * _signVspd);
	_deltaVspd	   -= vspdFraction;
	
	// Finally, perform a vertical collision check against the room collision. IF the Zoomer comes into 
	// contact with the floor, it will be set to GROUNDED and switch to its default state once again.
	var _yy = y + _deltaVspd;
	if (place_meeting(x, _yy, par_collider)){
		while(!place_meeting(x, y + _signVspd, par_collider))
			y += _signVspd;
		return;
	}
	y = _yy;
}

#endregion

// Once the create event has executed, initialize the Zoomer by setting it to its default state function.
initialize(state_default);