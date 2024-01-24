#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// 
maxHspd			= 0.6;	// Used for all movement directions.
maxVspd			= 4.0;	// Used only while falling.

// 
vAccel			= 0.25;	// Used only while falling.

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Zoomer will be able to 
// take four hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 4;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Zoomer. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 8;
stunDuration	= 8;

#endregion

#region Unique variable initialization

// Determines the direction that the Zoomer is currently moving in; right or left.
movement	= 0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Zoomer, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description 
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_zoomer, -1);
	create_weapon_collider(-8, -9, 14, 15, false);
	
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
	
	// 
	movement = choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	if (movement == MOVE_DIR_LEFT){
		hspd		= -maxHspd;
	} else{
		direction  -= 180.0;
		hspd		= maxHspd;
	}
}

#endregion

#region

/// @description 
/// @param {Real}	deltaHspd
/// @param {Real}	deltaVspd
/// @param {Bool}	ignoreSlopes
zoomer_world_collision = function(_deltaHspd, _deltaVspd, _ignoreSlopes){
	if (_deltaHspd == 0 && _deltaVspd == 0)
		return;
	
	// 
	if ((movement == MOVE_DIR_RIGHT && (direction == DIRECTION_NORTHEAST || direction == DIRECTION_SOUTHWEST)) 
			|| (movement == MOVE_DIR_LEFT && (direction == DIRECTION_NORTHWEST || direction == DIRECTION_SOUTHEAST))){
		zoomer_y_axis_collision(y + _deltaVspd);
		zoomer_x_axis_collision(x + _deltaHspd);
		return;
	}
	
	// 
	zoomer_x_axis_collision(x + _deltaHspd);
	zoomer_y_axis_collision(y + _deltaVspd);
}

/// @description 
/// @param {Real}	target	
zoomer_x_axis_collision = function(_target){
	if (_target == x) {return;}
	
	var _signHspd	= sign(hspd);
	if (place_meeting(_target, y, par_collider)){
		while(!place_meeting(x + _signHspd, y, par_collider))
			x += _signHspd;
			
	} else{
		while(x != _target){
			if (!place_meeting(x + _signHspd, y, par_collider))
				x += _signHspd;
			
			if (!place_meeting(x, y + lengthdir_y(1, direction), par_collider)){
				hspd		 = 0.0;
				hspdFraction = 0.0;
				break;
			}
		}
	}
}

/// @description
/// @param {Real}	target
zoomer_y_axis_collision = function(_target){
	if (_target == y) {return;}
	
	var _signVspd	= sign(vspd);
	if (place_meeting(x, _target, par_collider)){
		while(!place_meeting(x, y + _signVspd, par_collider))
			y += _signVspd;

	} else{
		while(y != _target){
			if (!place_meeting(x, y + _signVspd, par_collider))
				y += _signVspd;
			
			if (!place_meeting(x + lengthdir_x(1, direction), y, par_collider)){
				vspd		 = 0.0;
				vspdFraction = 0.0;
				break;
			}
		}
	}
}

/// @description 
/// @param {Real}	direction
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

/// @description 
/// @param {Real}	direction
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

/// @description 
state_default = function(){
	// 
	var _below = direction - (45.0 * movement);
	var _xx = x + get_next_x_position(_below);
	var _yy = y + get_next_y_position(_below);
	if (!place_meeting(_xx, _yy, par_collider)){
		direction = _below;
		hspdFraction = 0.0;
		vspdFraction = 0.0;
		
		// 
		_below = direction - (45.0 * movement);
		_xx = x + get_next_x_position(_below);
		_yy = y + get_next_y_position(_below);
		if (!place_meeting(_xx, _yy, par_collider)){
			direction = _below;
			
			// 
			_below = direction - (90.0 * movement);
			_xx = x + get_next_x_position(_below);
			_yy = y + get_next_y_position(_below);
			if (!place_meeting(_xx, _yy, par_collider)){
				object_set_next_state(state_falling);
				stateFlags  &= ~DNTT_GROUNDED;
				direction	 = (movement == MOVE_DIR_RIGHT) ? DIRECTION_EAST : DIRECTION_WEST;
				hspd		 = 0.0;
				vspd		 = 0.0;
				hspdFraction = 0.0;
				vspdFraction = 0.0;
				return;
			}
		}
	}
	
	// 
	hspd = lengthdir_x(maxHspd, direction);
	vspd = lengthdir_y(maxHspd, direction);
	apply_frame_movement(zoomer_world_collision);
	
	// 
	_xx = x + get_next_x_position(direction);
	_yy = y + get_next_y_position(direction);
	if (place_meeting(_xx, _yy, par_collider)){
		direction += (45.0 * movement);
		hspdFraction = 0.0;
		vspdFraction = 0.0;
		
		// 
		_xx = x + get_next_x_position(direction);
		_yy = y + get_next_y_position(direction);
		if (place_meeting(_xx, _yy, par_collider))
			direction += (45.0 * movement);
	}
}

/// @description 
state_falling = function(){
	apply_gravity(maxVspd);
	if (DNTT_IS_GROUNDED){
		object_set_next_state(state_default);
		return;
	}
	
	apply_frame_movement(entity_world_collision, true);
}

#endregion

// Once the create event has executed, initialize the Zoomer by setting it to its default state function.
initialize(state_default);