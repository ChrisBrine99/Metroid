#region Macro value initializations

// Macros for each of the bits in the variable "stateFlags". These bits will all determine how the projectile
// functions and interacts with the world depending on which are set (1) and which are not (0).
#macro	TYPE_POWER_BEAM			0
#macro	TYPE_ICE_BEAM			1
#macro	TYPE_TESLA_BEAM			2
#macro	TYPE_PLASMA_BEAM		3
#macro	TYPE_MISSILE			4
#macro	TYPE_SUPER_MISSILE		5
#macro	TYPE_ICE_MISSILE		6
#macro	TYPE_SHOCK_MISSILE		7
#macro	PROJ_CHARGED			17
#macro	PROJ_MOVE_RIGHT			18
#macro	PROJ_MOVE_LEFT			19
#macro	PROJ_MOVE_UP			20
#macro	PROJ_MOVE_DOWN			21
#macro	IGNORE_WALLS			22
#macro	IGNORE_ENTITIES			23

// Macro statements that condense the code required for checking each of the state flags found within the
// player projectile's "stateFlags" variable; which vastly differ from those found in other dynamic entities.
#macro	IS_MISSILE				(stateFlags & ((1 << TYPE_MISSILE) | (1 << TYPE_SUPER_MISSILE) | (1 << TYPE_ICE_MISSILE) | (1 << TYPE_SHOCK_MISSILE)))
#macro	IS_COLD_BASED			(stateFlags & ((1 << TYPE_ICE_BEAM) | (1 << TYPE_ICE_MISSILE))
#macro	IS_SHOCK_BASED			(stateFlags & ((1 << TYPE_TESLA_BEAM) | (1 << TYPE_SHOCK_MISSILE))
#macro	IS_CHARGED				(stateFlags & (1 << PROJ_CHARGED))
#macro	IS_MOVING_RIGHT			(stateFlags & (1 << PROJ_MOVE_RIGHT))
#macro	IS_MOVING_LEFT			(stateFlags & (1 << PROJ_MOVE_LEFT))
#macro	IS_MOVING_UP			(stateFlags & (1 << PROJ_MOVE_UP))
#macro	IS_MOVING_DOWN			(stateFlags & (1 << PROJ_MOVE_DOWN))
#macro	IS_MOVING_HORIZONTAL	(stateFlags & ((1 << PROJ_MOVE_RIGHT) | (1 << PROJ_MOVE_LEFT)))
#macro	IS_MOVING_VERTICAL		(stateFlags & ((1 << PROJ_MOVE_UP) | (1 << PROJ_MOVE_DOWN)))
#macro	CAN_IGNORE_WALLS		(stateFlags & (1 << IGNORE_WALLS))
#macro	CAN_IGNORE_ENTITIES		(stateFlags & (1 << IGNORE_ENTITIES))

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

#endregion

#region Unique variable initializations

// All projectiles will have a set amount of damage they will deal to any hostile objects they come into
// contact with. So, this parent object will be where it's initialized at a default of zero damage.
damage = 0;

#endregion

#region Projectile initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
__initialize = initialize;
/// @description 
/// @param {Function}	state			The state to initially use for the projectile in question. 
/// @param {Real}		x				Samus's horizontal position in the room.
/// @param {Real}		y				Samus's vertical position in the room.
/// @param {Real}		imageXScale		Samus's current facing direction (1 == right, -1 == left).
/// @param {Bool}		isCharged		Determines if the projectile is charged or not.
initialize = function(_state, _x, _y, _imageXScale, _isCharged){
	__initialize(_state); // Calls initialize function found in "par_dynamic_entity".
	set_initial_position(_x, _y, _imageXScale);
	stateFlags |= (1 << DRAW_SPRITE);
	// Damage is always quadrupled for a charged projectile and the bit flag is flipped in case the fact that 
	// the projectile is charged needs to be referenced after creation.
	if (_isCharged){
		stateFlags |= (1 << PROJ_CHARGED);
		damage = damage * 4;
	}
}

#endregion

#region Projectile utility functions

/// @description Sets up the projectile to come from the position of the beam in Samus's current sprite/animation
/// rather than her actual position in the room, which is located at the center of her feet. Also determines
/// where the projectile will travel (up, down, left, or right) depending on the direction of the beam in the
/// sprite.
/// @param {Real}	x				Samus's current X position.
/// @param {Real}	y				Samus's current Y position.
/// @param {Real}	imageXScale		Samus's "image_xscale" value (Determines her facing direction).
set_initial_position = function(_x, _y, _imageXScale){
	// First, grab some state bits from Samus, which are then used to determine the offset used to reach the
	// beam's position in her current sprite/animation.
	var _stateFlags = 0;
	with(PLAYER) {_stateFlags |= (stateFlags & ((1 << CROUCHING) | (1 << MOVING)  | (1 << GROUNDED) | (1 << AIMING_DOWN) | (1 << AIMING_UP)));}
	
	// Determine the direction Samus is aiming in by checking the "aiming up" and "aiming down" flags, 
	// respectively. The "aiming front" flag is ignored because if this variable doesn't return true for the
	// other two options, Samus's beam has to be aiming forward.
	var _aimDirection = (_stateFlags & ((1 << AIMING_DOWN) | (1 << AIMING_UP)));
	switch(_aimDirection){
		default: // Aiming forward (Can be standing, walking, crouching, or airbourne).
			if ((_stateFlags & (1 << GROUNDED)) != 0){
				if ((_stateFlags & (1 << CROUCHING)) != 0){
					// Crouching Offset // 
					x = _x + (14 * _imageXScale);
					y = _y - 13;
				} else{
					if ((_stateFlags & (1 << MOVING)) != 0){
						// Walking Offset //
						x = _x + (17 * _imageXScale);
						y = _y - 27;
					} else{
						// Standing Offset //
						x = _x + (15 * _imageXScale);
						y = _y - 23;
					}
				}
			} else{
				// Jumping Offset // 
				x = _x + (15 * _imageXScale);
				y = _y - 23;
			}
			// Set movement direction flag based on the direction Samus is facing horizontally. Then, apply
			// that facing direction to the beam's sprite itself so it matches Samus.
			if (_imageXScale == 1)	{stateFlags |= (1 << PROJ_MOVE_RIGHT);}
			else					{stateFlags |= (1 << PROJ_MOVE_LEFT);}
			image_xscale = _imageXScale;
			break;
		case (1 << AIMING_UP): // Aiming upward (Can be standing, walking, or airbourne).
			if ((_stateFlags & (1 << GROUNDED)) != 0){
				if ((_stateFlags & (1 << MOVING)) != 0){
					// Walking Offset //
					x = _x + (2 * _imageXScale);
					y = _y - 46;
				} else{
					// Standing Offset // 
					x = _x + (3 * _imageXScale);
					y = _y - 46;
				}
			} else{
				// Jumping Offset //
				x = _x + (3 * _imageXScale);
				y = _y - 46;
			}
			stateFlags |= (1 << PROJ_MOVE_UP);
			image_angle = 90;
			break;
		case (1 << AIMING_DOWN): // Aiming downward (Only possible while airbourne).
			x = _x + (4 * _imageXScale);
			y = _y - 9;
			stateFlags |= (1 << PROJ_MOVE_DOWN);
			image_angle = 270;
			break;
	}
}

/// @description Processing collision between the projectile and the world's collision. Unlike normal entities,
/// projectiles will perform their collisions using a line check; allowing them to move as fast as they wish
/// without running into the issue of the projectile moving through walls due to said speed.
/// @param {Real}	deltaHspd	Movement along the X-axis in whole pixels for the current frame.
/// @param {Real}	deltaVspd	Movement along the Y-axis in whole pixels for the current frame.
projectile_world_collision = function(_deltaHspd, _deltaVspd){
	// If the projectile has been flagged to ignore wall collision, the function's collision check is skipped
	// and the movement velocities for both the horizontal and vertical axes will simply be added to the current
	// position of the projectile.
	if (CAN_IGNORE_WALLS){
		x += _deltaHspd;
		y += _deltaVspd;
		return;
	}
	
	// If the projectile is set to collide with walls, perform the line collision here; including both velocities
	// at once to create an accurate line of movement for the frame. If the function returns true, the values
	// for movement are set to 0 and the projectile is flagged for destruction.
	if (collision_line(x, y, x + _deltaHspd, y + _deltaVspd, obj_collider, true, true)){
		stateFlags |= (1 << DESTROYED);
		_deltaHspd = 0;
		_deltaVspd = 0;
	}
	x += _deltaHspd;
	y += _deltaVspd;
}

/// @description Handles collision between a player projectile and any potential destructible objects in the
/// world. This function is called directly after the world collision function for the projectile has executed.
/// As a result, the collision checks for one pixel in the relevant movement directions for a destructible.
collision_destructible_objects = function(){
	var _destructible = instance_place(x + sign(hspd), y + sign(vspd), par_destructible);
	with(_destructible){
		// Don't bother checking for collision with a block that hhas already been destroyed. If the block
		// hasn't been destroyed, the first thing that occurs is the block will be revealed to the player.
		if (IS_DESTROYED) {return;}
		stateFlags &= ~(1 << HIDDEN);
		
		// Check while destructible block is being collided with by checking the index given to the object
		// by GameMaker itself (Stored in the "object_index" variable). For missile blocks, the only way to
		// destroy them is with a projectile that's considered a missile, but the generic block and item ball
		// can be broken by any and all player projectiles.
		var _isDestroyed = false;
		switch(object_index){
			case obj_destructible_all:
			case obj_destructible_collectible_ball:	_isDestroyed = true;				break;
			case obj_destructible_missile:			_isDestroyed = IS_MISSILE;			break;
		}
		
		// Only trigger the destruction of the specified block if the switch statement resulted in 
		// "_isDestroyed" being set to true.
		if (_isDestroyed) {destructible_destroy_self();}
	}
	if (_destructible != noone && !CAN_IGNORE_WALLS) {stateFlags |= (1 << DESTROYED);}
}

#endregion