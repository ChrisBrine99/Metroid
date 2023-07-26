#region Macro value initializations

// Macros for each of the bits in the variable "stateFlags". These bits will all determine how the projectile
// functions and interacts with the world depending on which are set (1) and which are not (0).
#macro	TYPE_POWER_BEAM			0
#macro	TYPE_ICE_BEAM			1
#macro	TYPE_WAVE_BEAM			2
#macro	TYPE_PLASMA_BEAM		3
#macro	TYPE_MISSILE			4
#macro	TYPE_SUPER_MISSILE		5
#macro	TYPE_ICE_MISSILE		6
#macro	TYPE_SHOCK_MISSILE		7
#macro	PROJ_CHARGED			14
#macro	PROJ_MOVE_RIGHT			15
#macro	PROJ_MOVE_LEFT			16
#macro	PROJ_MOVE_UP			17
#macro	PROJ_MOVE_DOWN			18
#macro	IGNORE_WALLS			19
#macro	IGNORE_ENTITIES			20

// Macro statements that condense the code required for checking each of the state flags found within the
// player projectile's "stateFlags" variable; which vastly differ from those found in other dynamic entities.
#macro	IS_MISSILE				(stateFlags & ((1 << TYPE_MISSILE) | (1 << TYPE_SUPER_MISSILE) | (1 << TYPE_ICE_MISSILE) | (1 << TYPE_SHOCK_MISSILE)) != 0)
#macro	IS_COLD_BASED			(stateFlags & ((1 << TYPE_ICE_BEAM) | (1 << TYPE_ICE_MISSILE)) != 0)
#macro	IS_SHOCK_BASED			(stateFlags & ((1 << TYPE_WAVE_BEAM) | (1 << TYPE_SHOCK_MISSILE)) != 0)
#macro	IS_CHARGED				(stateFlags & (1 << PROJ_CHARGED) != 0)
#macro	IS_MOVING_RIGHT			(stateFlags & (1 << PROJ_MOVE_RIGHT) != 0)
#macro	IS_MOVING_LEFT			(stateFlags & (1 << PROJ_MOVE_LEFT) != 0)
#macro	IS_MOVING_UP			(stateFlags & (1 << PROJ_MOVE_UP) != 0)
#macro	IS_MOVING_DOWN			(stateFlags & (1 << PROJ_MOVE_DOWN) != 0)
#macro	IS_MOVING_HORIZONTAL	(stateFlags & ((1 << PROJ_MOVE_RIGHT) | (1 << PROJ_MOVE_LEFT)) != 0)
#macro	IS_MOVING_VERTICAL		(stateFlags & ((1 << PROJ_MOVE_UP) | (1 << PROJ_MOVE_DOWN)) != 0)
#macro	CAN_IGNORE_WALLS		(stateFlags & (1 << IGNORE_WALLS) != 0)
#macro	CAN_IGNORE_ENTITIES		(stateFlags & (1 << IGNORE_ENTITIES) != 0)

// Macro for the multiplier applied to a projectile if it happens to be charged.
#macro	CHARGE_MULTIPLIER		4.0

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

// Two lists that store collisions against children of "par_collider" and "par_enemy", respectively. These lists
// are cleared and refreshed frame-by-frame to determine what a projectile has collided with so each instance
// collided can be walked through and processed to see what should be done next.
colliderList	= ds_list_create();
enemyList		= ds_list_create();

// 
hitEntityIDs	= ds_list_create();

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
		damage = damage * CHARGE_MULTIPLIER;
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
						y = _y - 26;
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
					y = _y - 42;
				} else{
					// Standing Offset // 
					x = _x + (3 * _imageXScale);
					y = _y - 42;
				}
			} else{
				// Jumping Offset //
				x = _x + (3 * _imageXScale);
				y = _y - 42;
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
	if (_deltaHspd == 0 && _deltaVspd == 0) {return;}
	
	// First, clear the list of the previous frame's collision data. After that, check for collisions along the
	// line of movement for the projectile in question. After the initial collision_line check occurs, a check
	// against any special colliders is performed.
	ds_list_clear(colliderList);
	var _length = collision_line_list(x, y, x + _deltaHspd, y + _deltaVspd, par_collider, false, true, colliderList, true);
	var _collider = noone;
	for (var i = 0; i < _length; i++){
		_collider = colliderList[| i];
		if (_collider.object_index == obj_enemy_platform){ // Enemy collision should occur here; exit loop.
			projectile_enemy_collision(x + _deltaHspd, y + _deltaVspd);
			ds_list_clear(colliderList);
			return;
		}
		projectile_door_collision(_collider);
		projectile_destructible_collision(_collider);
		if (IS_DESTROYED) {break;}
	}

	// The projectile doesn't collide with the walls, ceilings, and floors in the world; move it to its next
	// position and exit the function early.
	if (CAN_IGNORE_WALLS){
		projectile_enemy_collision(x + _deltaHspd, y + _deltaVspd);
		x += _deltaHspd;
		y += _deltaVspd;
		return;
	}
	
	// There was one or more collisions found along the projectile's line of movement, so it will be destroyed
	// at the start of the next frame and its movement that should've occurred during this frame will be ignored.
	if (_length > 0){
		stateFlags &= ~(1 << DRAW_SPRITE);
		stateFlags |= (1 << DESTROYED);
		_deltaHspd = 0;
		_deltaVspd = 0;
		return;
	}
	projectile_enemy_collision(x + _deltaHspd, y + _deltaVspd);
	x += _deltaHspd;
	y += _deltaVspd;
}

/// @description Checks the projectile against a destructible collider to see if it can be destroyed. If it
/// can't destroy it, but the destructible was hidden, it will be revealed to the player until they leave the
/// room. Otherwise, it will be revealed and destroyed should it be weak to the projectile.
/// @param {Id.Instance}	instance
projectile_destructible_collision = function(_instance){
	var _isDestroyed = false;
	var _isMissile = IS_MISSILE;
	with(_instance){
		// Check to make sure the instance that is being checked is a child of "par_destructible". Otherwise,
		// the game will crash trying to access variables that don't exist on the object as the collision list
		// stores children of ANY collision object and not just the group this function processes. Also, ignore
		// the collision if the destructible is already destroyed.
		if (!object_is_ancestor(object_index, par_destructible) || IS_DESTROYED) {return;}
		
		// Check the index of this destructible against all possible destructilbe objects that can be destroyed
		// by one of the player's many projectile weapons. If the index matchs, another check will be performed
		// for the object to see if the projectile matches the destructible's weakness if necessary.
		switch(object_index){
			case obj_destructible_all:
			case obj_destructible_collectible_ball:	_isDestroyed = true;		break;
			case obj_destructible_missile:			_isDestroyed = _isMissile;	break;
		}
		
		// If the destruction of the object was a success, trigger it to destroy and play the animation for that
		// while also setting its hidden flag to false so it will be visible even after it has regenerated.
		if (_isDestroyed) {destructible_destroy_self();}
		stateFlags &= ~(1 << HIDDEN);
	}
	
	// Destroy the projectile if it can't pass through walls and the collision was a success.
	if (_isDestroyed && !CAN_IGNORE_WALLS) {stateFlags |= (1 << DESTROYED);}
}

/// @description Checks the projectile against the various door types that exist within the game to see if it
/// can destroy the door instance in question. Otherwise, it will leave the door as it is and destroy itself
/// only (If it can collide with the environment at all).
/// @param {Id.Instance}	instance
projectile_door_collision = function(_instance){
	var _isDestroyed = false;
	var _isMissile = IS_MISSILE;
	with(_instance){
		// Make sure the instance that is being checked is a child of the generic door object. Otherwise, the 
		// object will try to reference objects that don't exist in it and the game will crash due to the error.
		if (!object_is_ancestor(object_index, obj_general_door) && object_index != obj_general_door) {break;}
		
		// Check the door instance against all possible door objects to see which it matches up with; performing
		// a check against the projectile to see if it matches what is required to open the door.
		switch(object_index){
			default:						/* Play "ping" sound effect. */ break;
			case obj_general_door:			_isDestroyed = true;																			break;
			case obj_icebeam_door:			_isDestroyed = other.stateFlags & (1 << TYPE_ICE_BEAM) != 0;									break;
			case obj_wavebeam_door:			_isDestroyed = other.stateFlags & (1 << TYPE_WAVE_BEAM) != 0;									break;
			case obj_plasmabeam_door:		_isDestroyed = other.stateFlags & (1 << TYPE_PLASMA_BEAM) != 0;									break;
			case obj_missile_door:			_isDestroyed = _isMissile || flagID == EVENT_FLAG_INVALID;										break;
			case obj_super_missile_door:	_isDestroyed = other.stateFlags & (1 << TYPE_SUPER_MISSILE) || flagID == EVENT_FLAG_INVALID;	break;
			case obj_inactive_door:			_isDestroyed = inactive_door_collision();														break;
		}
		
		// If the door was successfully opened by the projectile, it will trigger the door to open by allowing
		// it to animate at full speed. Optionally, the flag for the door is set so it won't have to be unlocked
		// by the player again even after leaving the room.
		if (_isDestroyed){
			if (flagID != EVENT_FLAG_INVALID) {event_set_flag(flagID, true);}
			animSpeed = 1;
		}
	}
	
	// Destroy the projectile if it can't pass through walls and the collision was a success.
	if (_isDestroyed && !CAN_IGNORE_WALLS) {stateFlags |= (1 << DESTROYED);}
}

/// @description Checks collision against any enemy colliders the projectile instance may have come into contact
/// with during its step event call. Should a collision have occurred, it will be processed to determine if
/// damage should be inflicted on the Enemy, an ailment should be applied, it should be skipped, etc..
/// @param {Real}	x2	The target position on the x-axis that the projectile is moving to.
/// @param {Real}	y2	The target position on the y-axis that the projectile is moving to.
projectile_enemy_collision = function(_x2, _y2){
	// First, create some local variables that will be referenced throughout the collision(s). Each caches an
	// aspect or characteristic about the projectile, so these properties can be easily referenced when inside
	// the scope of a given collider.
	var _hitEntityIDs	= hitEntityIDs;
	var _damage			= damage;
	var _stateFlags		= stateFlags;
	var _ignoreEntities = CAN_IGNORE_ENTITIES;
	var _isColdBased	= IS_COLD_BASED;
	
	// Perform a line check that orders all collisions based on distance from the (x1, y1) coordinate; storing
	// it all in a ds_list that is then looped through to process what will happen to the projectile and the
	// enemy(s) in question relative to the resulting collision(s).
	var _length			= collision_line_list(x, y, _x2, _y2, obj_enemy_collider, false, true, enemyList, true);
	for (var i = 0; i < _length; i++){
		with(enemyList[| i]){
			// First, check if the collider is considered an "immunity area". If so, the projectile will be
			// immediately destroyed and the for loop through all collider collisions will exit early should
			// the projectile not have its "IGNORE_ENTITIES" flags set to 1.
			if (isImmunityArea){
				if (!_ignoreEntities){
					_stateFlags |= (1 << DESTROYED);
					break;
				}
				continue; // Move onto next collider if the projectile wasn't destroyed.
			}
			
			// The collider itself doesn't store any information, so the rest of the loop is passed off to the
			// Enemy object that is attached to said collider.
			with(parentID){
				// Check if the entity has already been hit by the projectile. This ensures that a single
				// projectile can't deal damage to an entity more than once if that situation were to ever
				// occur during runtime. A current hitstunned Enemy will also not take damage.
				if (ds_list_find_index(_hitEntityIDs, id) != -1 || IS_HIT_STUNNED)
					continue;
				ds_list_add(_hitEntityIDs, id);
			
				// 
				if (!inflict_freeze(_damage, _isColdBased) && is_weak_to_weapon(_stateFlags))
					entity_apply_hitstun(8, _damage);
			}
		}
		
		// After the collider has been processed, a check to see if the projectile should be deleted is
		// performed. The only projectile weapon that bypasses this is the Plasma Beam.
		if (!_ignoreEntities){
			_stateFlags |= (1 << DESTROYED);
			break; // Projectile was destroyed; break out of the loop early.
		}
	}
	
	// Finally, clear out the list of collisions and update the projectile's state flags to match any 
	// adjustments made during the processing of said collisions.
	if (ds_list_size(enemyList) > 0) {ds_list_clear(enemyList);}
	stateFlags = _stateFlags;
}

#endregion