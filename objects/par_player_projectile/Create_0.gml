#region Macro value initializations

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. These represent states and properties that don't //
//  need to be tied to a specific function due to these states being allowed across multiple main states.  //																						   //
// ------------------------------------------------------------------------------------------------------- //

// --- Beam Projectile Substates --- //
#macro	PROJ_POWBEAM			0x00000001
#macro	PROJ_ICEBEAM			0x00000002
#macro	PROJ_WAVBEAM			0x00000004
#macro	PROJ_PLSBEAM			0x00000008
#macro	PROJ_CHRBEAM			0x00000010
// --- Missile Projectile Substates --- //
#macro	PROJ_REGMISSILE			0x00000020
#macro	PROJ_SUPMISSILE			0x00000040
#macro	PROJ_ICEMISSILE			0x00000080
#macro	PROJ_SHKMISSILE			0x00000100
// --- Movement Substates --- //
#macro	PROJ_MOVE_RIGHT			0x00008000
#macro	PROJ_MOVE_LEFT			0x00010000
#macro	PROJ_MOVE_UP			0x00020000
#macro	PROJ_MOVE_DOWN			0x00040000
// --- Collision Behaviour Substates --- //
#macro	PROJ_IGNORE_WALLS		0x00080000
#macro	PROJ_IGNORE_ENTITIES	0x00100000
// NOTE -- Bits 0x00200000 and greater are already in use by default dynamic entity substate flags.

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check what projectile substates are currently active.		   //
// ------------------------------------------------------------------------------------------------------- //

// --- Projectile Type Checks --- //
#macro	PROJ_IS_MISSILE			(stateFlags & (PROJ_REGMISSILE | PROJ_SUPMISSILE | PROJ_ICEMISSILE | PROJ_SHKMISSILE))
#macro	PROJ_IS_CHARGED			(stateFlags & PROJ_CHRBEAM)
// --- Ailment Infliction Checks --- //
#macro	PROJ_CAN_STUN			(stateFlags & (PROJ_REGMISSILE | PROJ_SUPMISSILE))
#macro	PROJ_CAN_SHOCK			(stateFlags & (PROJ_WAVBEAM | PROJ_SHKMISSILE))
#macro	PROJ_CAN_FREEZE			(stateFlags & (PROJ_ICEBEAM | PROJ_ICEMISSILE))
// --- Movement Substate Checks --- //
#macro	PROJ_MOVING_RIGHT		(stateFlags & PROJ_MOVE_RIGHT)
#macro	PROJ_MOVING_LEFT		(stateFlags & PROJ_MOVE_LEFT)
#macro	PROJ_MOVING_UP			(stateFlags & PROJ_MOVE_UP)
#macro	PROJ_MOVING_DOWN		(stateFlags & PROJ_MOVE_DOWN)
#macro	PROJ_MOVING_HORIZONTAL	(stateFlags & (PROJ_MOVE_RIGHT | PROJ_MOVE_LEFT))
#macro	PROJ_MOVING_VERTICAL	(stateFlags & (PROJ_MOVE_UP | PROJ_MOVE_DOWN))
// --- Collision Behaviour Substate Checks --- //
#macro	PROJ_IGNORES_WALLS		(stateFlags & PROJ_IGNORE_WALLS)
#macro	PROJ_IGNORES_ENTITIES	(stateFlags & PROJ_IGNORE_ENTITIES)

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
/// @description Initializes the projectile by applying the substate flags determined by the value of the final
/// argument in the function, as well as calling the function that sets the initial position of the projectile
/// relative to the position it was created at (Should be equal to Samus's current position).
/// @param {Function}	state			The state to initially use for the projectile in question. 
/// @param {Real}		x				Samus's horizontal position in the room.
/// @param {Real}		y				Samus's vertical position in the room.
/// @param {Real}		playerFlags		A copy of relevant substate flags carried over from Samus.
/// @param {Real}		flags			Substate flags that should be set by the projectile.
initialize = function(_state, _x, _y, _playerFlags, _flags){
	__initialize(_state); // Calls initialize function found in "par_dynamic_entity".
	stateFlags |= ENTT_DRAW_SELF | _flags;
	set_initial_position(_x, _y, _playerFlags);
}

#endregion

#region Projectile utility functions

/// @description Determines the position to place the projectile at relative to Samus's position at the time
/// of her creating it; her substate flags altering the outcome of this function.
/// @param {Real}	x				Samus's current X position within the room.
/// @param {Real}	y				Samus's current Y position within the room.
/// @param {Real}	playerFlags		Tracks Samus's substates that are required for properly positioning the projectile.
set_initial_position = function(_x, _y, _playerFlags){
	// First, determine if Samus is facing to the right (The "PLYR_FACING_RIGHT" bit being set) and set the
	// value for this local variable accordingly (-1 to represent left, +1 to represent right).
	var _facing = (_playerFlags & PLYR_FACING_RIGHT) ? MOVE_DIR_RIGHT : MOVE_DIR_LEFT;
	
	// If the projectile should move horizontally, this branch will be taken and the proper position will be
	// determines based on Samus's substate setup relative to the horizontal projectile movement.
	if (PROJ_MOVING_HORIZONTAL){
		image_xscale = _facing;	// Flips sprite horizontally if the projectile is moving left.
		
		// Samus is airborne, so the projectile is placed in the same region that her arm cannon is located
		// on her jumping sprite that has the arm cannon facing forward.
		if (!(_playerFlags & DNTT_GROUNDED)){
			x = _x + (15 * _facing);
			y = _y - 16;
			return;
		}
		
		// Samus is crouched, so the projectile is placed much like how it is for her airborne substate, but
		// lowered slightly to compensate for her arm cannon being lower in the sprite.
		if (_playerFlags & PLYR_CROUCHED){
			x = _x + (14 * _facing);
			y = _y - 13;
			return;
		}
		
		// Samus is walking in either direction, so place the projectile at the arm cannon's position while in
		// this substate (It's slightly higher than standing since her arm is higher while walking).
		if (_playerFlags & PLYR_MOVING){
			x = _x + (14 * _facing);
			y = _y - 26;
			return;
		}
		
		// The default position for the projectile if it's moving horizontally. This should only be used by
		// the projectile if Samus is standing still.
		x = _x + (15 * _facing);
		y = _y - 23;
		return;
	}
	
	// The projectile should be moving upward, which only has a difference in vertical offsets depending on if
	// Samus is airborne or not; the horizontal offset is the same for both conditions.
	if (PROJ_MOVING_UP){
		x = _x + (3 * _facing);
		
		if (!(_playerFlags & DNTT_GROUNDED)) {y = _y - 34;}
		else								 {y = _y - 42;}
		
		image_angle = 90;	// Rotate the projectile so it is facing upward.
		return;
	}
	
	// The projectile is moving downward, which should only occur while airborne. As it is also the most
	// uncommon way for a projectile to move, it's placed at the bottom of the function to avoid constantly
	// checking it during other states.
	if (PROJ_MOVING_DOWN){
		x = _x + (4 * _facing);
		y = _y - 3;
		image_angle = 270; // Rotate the projectile so it is facing downward.
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
	var _length			= collision_line_list(x, y, x + _deltaHspd, y + _deltaVspd, par_collider, false, true, colliderList, true);
	var _collider		= noone;
	for (var i = 0; i < _length; i++){
		_collider		= colliderList[| i];
		//if (_collider.object_index == obj_enemy_platform){ // Enemy collision should occur here; exit loop.
			//projectile_enemy_collision(x + _deltaHspd, y + _deltaVspd);
			//ds_list_clear(colliderList);
			//return;
		//}
		projectile_door_collision(_collider);
		projectile_destructible_collision(_collider);
		if (ENTT_IS_DESTROYED)
			break;
	}
	
	// 
	projectile_enemy_collision(x + _deltaHspd, y + _deltaVspd);

	// The projectile doesn't collide with the walls, ceilings, and floors in the world; move it to its next
	// position and exit the function early.
	if (PROJ_IGNORES_WALLS){
		x += _deltaHspd;
		y += _deltaVspd;
		return;
	}
	
	// There was one or more collisions found along the projectile's line of movement, so it will be destroyed
	// at the start of the next frame and its movement that should've occurred during this frame will be ignored.
	if (_length > 0){
		stateFlags &= ~ENTT_DRAW_SELF;
		stateFlags |=  ENTT_DESTROYED;
		_deltaHspd = 0;
		_deltaVspd = 0;
		return;
	}
	x += _deltaHspd;
	y += _deltaVspd;
}

/// @description Checks the projectile against a destructible collider to see if it can be destroyed. If it
/// can't destroy it, but the destructible was hidden, it will be revealed to the player until they leave the
/// room. Otherwise, it will be revealed and destroyed should it be weak to the projectile.
/// @param {Id.Instance}	instance
projectile_destructible_collision = function(_instance){
	var _isDestroyed = false;
	var _isMissile = PROJ_IS_MISSILE;
	with(_instance){
		// Check to make sure the instance that is being checked is a child of "par_destructible". Otherwise,
		// the game will crash trying to access variables that don't exist on the object as the collision list
		// stores children of ANY collision object and not just the group this function processes. Also, ignore
		// the collision if the destructible is already destroyed.
		if (!object_is_ancestor(object_index, par_destructible) || ENTT_IS_DESTROYED) 
			return;
		
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
		stateFlags &= ~DEST_HIDDEN;
	}
	
	// Destroy the projectile if it can't pass through walls and the collision was a success.
	if (_isDestroyed && !PROJ_IGNORES_WALLS) {stateFlags |= ENTT_DESTROYED;}
}

/// @description Checks the projectile against the various door types that exist within the game to see if it
/// can destroy the door instance in question. Otherwise, it will leave the door as it is and destroy itself
/// only (If it can collide with the environment at all).
/// @param {Id.Instance}	instance
projectile_door_collision = function(_instance){
	var _isDestroyed = false;
	var _isMissile = PROJ_IS_MISSILE;
	with(_instance){
		// Make sure the instance that is being checked is a child of the generic door object. Otherwise, the 
		// object will try to reference objects that don't exist in it and the game will crash due to the error.
		if (!object_is_ancestor(object_index, obj_general_door) && object_index != obj_general_door)
			break;
		
		// Check the door instance against all possible door objects to see which it matches up with; performing
		// a check against the projectile to see if it matches what is required to open the door.
		switch(object_index){
			case obj_general_door:			
				_isDestroyed = true;
				break;
			case obj_icebeam_door:	
				if (other.stateFlags & PROJ_ICEBEAM)
					_isDestroyed = true;
				break;
			case obj_wavebeam_door:	
				if (other.stateFlags & PROJ_WAVBEAM)
					_isDestroyed = true;
				break;
			case obj_plasmabeam_door:		
				if (other.stateFlags & PROJ_PLSBEAM)
					_isDestroyed = true;
				break;
			case obj_missile_door:
				if (_isMissile || flagID == EVENT_FLAG_INVALID)
					_isDestroyed = true;
				break;
			case obj_super_missile_door:
				if (other.stateFlags & PROJ_SUPMISSILE || flagID == EVENT_FLAG_INVALID)
					_isDestroyed = true;
				break;
			case obj_inactive_door:			
				_isDestroyed = inactive_door_collision();
				break;
		}
		
		// If the door was successfully opened by the projectile, it will trigger the door to open by allowing
		// it to animate at full speed. Optionally, the flag for the door is set so it won't have to be unlocked
		// by the player again even after leaving the room.
		if (_isDestroyed){
			if (flagID != EVENT_FLAG_INVALID) 
				event_set_flag(flagID, true);
			stateFlags |= DOOR_OPENED;
			animSpeed	= DOOR_OPEN_ANIM_SPEED;
		}
	}
	
	// Destroy the projectile if it can't pass through walls and the collision was a success.
	if (_isDestroyed && !PROJ_IGNORES_WALLS) {stateFlags |= ENTT_DESTROYED;}
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
	var _ignoreEntities = PROJ_IGNORES_ENTITIES;
	var _canFreeze		= PROJ_CAN_FREEZE;
	
	// Perform a line check that orders all collisions based on distance from the (x1, y1) coordinate; storing
	// it all in a ds_list that is then looped through to process what will happen to the projectile and the
	// enemy(s) in question relative to the resulting collision(s).
	var _length	= collision_line_list(x, y, _x2, _y2, obj_enemy_collider, false, true, enemyList, true);
	for (var i = 0; i < _length; i++){
		with(enemyList[| i]){
			// First, check if the collider is considered an "immunity area". If so, the projectile will be
			// immediately destroyed and the for loop through all collider collisions will exit early should
			// the projectile not have its "IGNORE_ENTITIES" flags set to 1.
			if (isImmunityArea){
				if (audioComponent) // Only play the sound effect if the enemy has an audio component.
					audioComponent.play_sound(snd_ineffective, SND_TYPE_GENERAL, false, true, 0.5);
				if (!_ignoreEntities){
					_stateFlags |= ENTT_DESTROYED;
					break;
				}
				continue; // Move onto next collider if the projectile wasn't destroyed.
			}
			
			// The collider itself doesn't store any information, so the rest of the loop is passed off to the
			// Enemy object that is attached to said collider.
			with(parentID){
				// Check if the entity has already been hit by the projectile. This ensures that a single
				// projectile can't deal damage to an entity more than once if that situation were to ever
				// occur during runtime.
				if (ds_list_find_index(_hitEntityIDs, id) != -1)
					continue;
				ds_list_add(_hitEntityIDs, id);
				
				// 
				if (!(weaknessFlags & _stateFlags)){
					if (audioComponent) // Only play the sound effect if the enemy has an audio component.
						audioComponent.play_sound(snd_ineffective, SND_TYPE_GENERAL, false, true, 0.5);
					continue;
				}
				
				// 
				if (!inflict_freeze(_damage, _canFreeze))
					entity_apply_hitstun(8.0, _damage);
			}
		}
		
		// After the collider has been processed, a check to see if the projectile should be deleted is
		// performed. The only projectile weapon that bypasses this is the Plasma Beam.
		if (!_ignoreEntities){
			_stateFlags |= ENTT_DESTROYED;
			break; // Projectile was destroyed; break out of the loop early.
		}
	}
	
	// Finally, clear out the list of collisions and update the projectile's state flags to match any 
	// adjustments made during the processing of said collisions.
	if (ds_list_size(enemyList) > 0) {ds_list_clear(enemyList);}
	stateFlags = _stateFlags;
}

#endregion