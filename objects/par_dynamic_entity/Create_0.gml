#region Macros utilized by all dynamic entities

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. They represent substates for bits that are       //
//	unique to dynamic entities; altering their general functionality based on the value stored at these	   //
//	bit position in the variable.																		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DNTT_DESTRUCTIBLE			0x00200000
#macro	DNTT_GROUNDED				0x00400000
// NOTE --	Bits 0x00800000 and greater are in use and can be found within "par_entity_data" as it shares 
//			those substate flags with "par_static_entity" as well.

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check for these general Entity substates.					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DNTT_IS_DESTRUCTIBLE	(stateFlags & DNTT_DESTRUCTIBLE)
#macro	DNTT_IS_GROUNDED		(stateFlags & DNTT_GROUNDED)

#endregion

#region Editing default variables, initializing unique variables, and other important initializations

// Edit some of the object's default variables before any initialization of unique variables occurs.
direction		= 0.0;
sprite_index	= NO_SPRITE;
image_index		= 0;
image_speed		= 0.0;
visible			= false;

// The three state variables, which will store the currently execution state function, the previous state
// state function that was in use, and the next available state function to swap too at the beginning of the
// next frame (The state won't change whenever "curState" and "nextState" store the same function pointer).
curState		= NO_STATE;
lastState		= NO_STATE;
nextState		= NO_STATE;

// 32-bits that can each represent their own functionality within any children of this object. However, the 
// top eight bits are reserved for generic flags that are required for an entity to function properly.
stateFlags = ENTT_ACTIVE;

// Variables for keeping track of and manipulating an audio component that can optionally be attached to an
// entity. The first variable stores the pointer to the attached component, whereas the last two variables
// allow the component to be offset from the entity's position based on their respective values.
audioComponent	= noone;
audioOffsetX	= 0;
audioOffsetY	= 0;

// Much like above, this group of variables will keep track of and manipulate a component, but its focus is
// the optional light component that can be attached to an entity. The first variable stores the pointer,
// and the last two store the offset position to place the light at relative to the entity's position.
lightComponent	= noone;
lightOffsetX	= 0;
lightOffsetY	= 0;

// Unused variables that's a holdover from Project Dread since both projects use the same base functionalities.
// interactComponent = noone;

// Variables for animating the current sprite appliex to an entity. They replace the standard built-in animation
// variables like "image_speed" and "image_index" to allow for frame-independent animations. The speed of the
// animation can be manipulated further by changing the value of "animSpeed". Finally, the loop offset determines
// which frame of animation will be the start of the animation; allowing for introduction frames if necessary.
imageIndex		= 0;
animSpeed		= 0.0;
spriteLength	= 0;
spriteSpeed		= 0;
loopOffset		= 0;

// The current values for the horiztonal and vertical velocities of the entity, respectively. Regardless of
// these values, they will always allow for frame-independent physics and whole-number movement when paired
// with the "apply_frame_movement" function found in this parent object.
hspd = 0.0;
vspd = 0.0;

// The current horizontal and vertical acceleration values for the entity, as well as their factors to allow
// real-time adjustments to their values without actually overwriting those values.
hAccel			= 0.0;
vAccel			= 0.0;
hAccelFactor	= 1.0;
vAccelFactor	= 1.0;

// The maximum possible horizontal movement speed, and the maximum falling speed OR vertical movement speed
// (This can change depending on the entity in question). Much like acceleration, the maximum velocity values
// allow for real-time adjustment of said values without having to overwrite those values.
maxHspd			= 0.0;
maxVspd			= 0.0;
maxHspdFactor	= 1.0;
maxVspdFactor	= 1.0;

// Variables that are responsible for storing the decimal values of the horizontal and vertical celocities,
// respectively. Once a whole number exists within these values, they will be parsed out and used for entity
// movement/collision detection; leaving the decimals within the respective values.
hspdFraction = 0.0;
vspdFraction = 0.0;

// The number of hitpoints the entity has currently, as well as the maximum possible value they can have. Once
// the entity's hitpoints reach or go below a value of zero, they will be destroyed at the start of the next 
// frame (If the flag for invulnerability isn't set to 1).
hitpoints		= 0;
maxHitpoints	= 0;

// Variables for tracking the current duration of a hitstun and the total length required for the hitstun to
// end its effects, repsectively. The final variables determine how long AFTER the hitstun that the entity will
// remain immune to attacks for.
hitstunTimer	= -1.0;
hitstunLength	=  0.0;
recoveryTimer	= -1.0;
recoveryLength	=  0.0;

#endregion

#region Functions for use in all children of the dynamic entity object

/// @description Gets the current values for horizontal and vertical acceleration for the entity. The "factor"
/// values for each of these determine what will actually be returned relative to the entity's base values.
get_hor_accel = function()	{return hAccel * hAccelFactor;}
get_vert_accel = function() {return vAccel * vAccelFactor;}

/// @description Gets the current maximum horizontal and vertical velocities for the entity, which factor in
/// the current "factor" values for each of those velocities. Allows manipulation of these maximums without
/// overwriting them in order to change them.
get_max_hspd = function() {return maxHspd * maxHspdFactor;}
get_max_vspd = function() {return maxVspd * maxVspdFactor;}

/// @description The default initialization for an entity, which will set itself to visible and also assign
/// a starting state to them. This function can be overridden and modified to include initialization of
/// attributes that only exist to specific entities if need be.
/// @param {Function}	state	The function to use for this entity's initial state.
initialize = function(_state){
	object_set_next_state(_state);
	visible = true;
}

/// @description Default function for apply damage and a hitstun to the entity. This basic form of the function
/// will simply reduce the hitpoints of the entity by whatever the "_damage" amount is (A positive number here
/// will reduce their health; a negative value increasing it, respectively). The default flag for "hitstun" will
/// be flipped to true until the duration of the stun has ended.
/// @param {Real}	duration	Time in "frames" to apply the hitstun (Excluding the recovery) for (60 frames = 1 second).
/// @param {Real}	damage		Damage to deduct to the entity's current hitpoints.
entity_apply_hitstun = function(_duration, _damage = 0){
	update_hitpoints(-_damage);
	stateFlags	   |= ENTT_HIT_STUNNED;
	hitstunLength	= _duration;
	hitstunTimer	= 0.0;
	recoveryTimer	= 0.0;
}

/// @description A simple function that applies a modifier value to the entity's current hitpoints. It will
/// automatically prevent the value from exceeding whatever the maximum hitpoints has been set to for the
/// entity, while also flagging their destruction if they go below zero hitpoints.
/// @param {Real}	modifier	The value that will be subtracted (Argument is negative) or added (Argument is positive) to the entity's hitpoints.
update_hitpoints = function(_modifier){
	hitpoints	   += _modifier;
	if (hitpoints > maxHitpoints){ // Prevent exceeding maximum possible hitpoints.
		hitpoints	= maxHitpoints;
	} else if (hitpoints <= 0){ // Set the entity to "destroyed" by flipping that respective flag.
		object_set_next_state(NO_STATE);
		stateFlags |= ENTT_DESTROYED;
		hitpoints	= 0;
	}
}

/// @description The default gravity function, which applies downward movement to the entity's vspd value until
/// the maximum vertical falling speed has been reached. Once the ground has been reached, the flag to signify
/// that state is flipped and the vspd value is reset to 0.
/// @param {Real}	maxFallSpeed
apply_gravity = function(_maxFallSpeed){
	var _onGround		= place_meeting(x, y + 1, par_collider);
	if (!_onGround){
		stateFlags	   &= ~DNTT_GROUNDED;
		vspd		   += get_vert_accel() * DELTA_TIME;
		if (vspd > _maxFallSpeed)
			vspd		= _maxFallSpeed;
	} else if (!DNTT_IS_GROUNDED && vspd >= 0.0 && _onGround){
		stateFlags	   |= DNTT_GROUNDED;
		vspdFraction	= 0.0;
		vspd			= 0.0;
	}
}

/// @description Applies the current value for delta time to the entity's horizontal and vertical movement
/// values so they accurate simulate 60fps physics with an unlocked frame rate. After that is performed, an
/// optional collision function can be called upon with the non-fractional movement values.
/// 
/// NOTE -- These functions must include two arguments for the "deltaHspd" and "deltaVspd" values calculated
///			within this function or else the game will likely crash.
/// 
/// @param {Function}	collisionFunction	Optional function to calculate world collision with against current frame's movement.
/// @param {Bool}		ignoreSlopes		Optional flag that can prevent the Entity from moving along sloped surfaces.
apply_frame_movement = function(_collisionFunction = NO_FUNCTION, _ignoreSlopes = false){
	// Store the current delta time value in a local variable since it will be used to calculate both the
	// horizontal and vertical velocities from the current frame.
	var _deltaTime = DELTA_TIME;
	
	// Convert horizontal velocity from a floating point number to an integer by removing the fractional
	// value from the "_deltaHspd" value; storing it in "hspdFraction" until a whole number can be parsed from
	// said variable.
	var _deltaHspd		= hspd * _deltaTime;
	if (_deltaHspd != 0.0){
		_deltaHspd	   += hspdFraction;	// Add previous fraction to combine it with the new fractional value.
		hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * sign(_deltaHspd));
		_deltaHspd	   -= hspdFraction;
	}
	
	// Convert the vertical velocity from a floating point number to an integer by removing the fractional
	// value from the "_deltaVspd" value; storing it in "vspdFraction" until a whole number can be parsed from
	// said variable.
	var _deltaVspd		= vspd * _deltaTime;
	if (_deltaVspd != 0.0){
		_deltaVspd	   += vspdFraction;	// Add previous fraction to combine it with the new fractional value.
		vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * sign(_deltaVspd));
		_deltaVspd	   -= vspdFraction;
	}

	// Finally, call the collision function specified for the Entity if there was one provided, which will 
	// handle collision between said Entity and the world collider objects. Otherwise, their delta hspd and
	// vspd values will simply be added to their positions if they don't process world collision.
	if (_collisionFunction != NO_FUNCTION){
		_collisionFunction(_deltaHspd, _deltaVspd, _ignoreSlopes);
	} else if (_deltaHspd != 0 || _deltaVspd != 0){
		x += _deltaHspd;
		y += _deltaVspd;
	}
}

/// @description Checks for collision between the entity and the world's collision bounds. If no collision is
/// detected, the entity will be translated to their new position based on the hspd and vspd values provided
/// in the function's parameters.
/// @param {Real}	deltaHspd		Movement along the X-axis in whole pixels for the current frame.
/// @param {Real}	deltaVspd		Movement along the Y-axis in whole pixels for the current frame.
/// @param {Bool}	ignoreSlopes	Bool that enables/disables Entity's ability to traverse slopes.
entity_world_collision = function(_deltaHspd, _deltaVspd, _ignoreSlopes){
	// HANDLING HORIZONTAL COLLISION -- If there is a non-zero value within "_deltaHspd" the branch will be
	// taken and collision along the x-axis is processed. This includes sloped floors if the entity is allowed
	// to move along such colliders.
	if (_deltaHspd != 0){
		var _destX = x + _deltaHspd;
		if (place_meeting(_destX, y, par_collider)){
			// HANDLING UPWARD SLOPES -- This branch is taken by entities that can move along upward slopes.
			// It utilizes their maximum horizontal velocity to determine the maximum slope height they can
			// reach before having the collider treated like a wall instead of a slope.
			if (!_ignoreSlopes){
				// Move pixel-by-pixel until the maximum allowed slope movement is reached OR there is no
				// longer an obstruction in front of the entity.
				var _maxSlope = floor(maxHspd);
				var _curSlope = 0;
				while(place_meeting(_destX, y - _curSlope, par_collider)){
					_curSlope++;
					if (_curSlope >= _maxSlope)
						break;
				}
					
				// After determining the maximum required slope movement for the entity, a final collision
				// check is used to see if that area is free in the event the while loop exited because
				// of the "(_curSlope == _maxSlope)" line. If the check passes, the entity is moved upward.
				if (!place_meeting(_destX, y - _curSlope, par_collider))
					y -= _curSlope;
			}
			
			// HANDLING PIXEL PERFECT MOVEMENT -- If the entity ignores slopes, the branch is taken and they
			// will be moved pixel-by-pixel until they meet with a collider. Otherwise, another check is made
			// to see if the entity is colliding along the x-axis relative to the y position that the slope
			// moved them up to before performing the collision code. Otherwise, the entity is simply moved
			// to their target x position since no collision was found after the slope movement.
			if (_ignoreSlopes || place_meeting(_destX, y, par_collider)){
				// Move pixel-by-pixel until the collider is reached.
				var _signHspd = sign(hspd);
				while(!place_meeting(x + _signHspd, y, par_collider)) 
					x += _signHspd;
				
				// Clear whatever values were stored for the entity's horizontal velocity.
				hspd = 0.0;
				hspdFraction = 0.0;
			} else{ // Final collision check for upward slope failed; entity can move to position with no issue.
				x = _destX;
			}
		} else{
			// HANDLING DOWNWARD SLOPES -- The entity will be moved pixel-by-pixel much like how the pixel-
			// perfect movement works when there is a collision, but there will be an additional check that 
			// considers if there is also a free spot one pixel below the entity vertically. If so, the entity 
			// is moved down along the sloped surface.
			if (!_ignoreSlopes && DNTT_IS_GROUNDED){
				var _signHspd	= sign(hspd);
				var _nextX		= abs(_destX - x);
				while(_nextX != 0){
					x += _signHspd;
					_nextX--;
					
					// The downward slope check occurs after each movement along the x-axis.
					if (!place_meeting(_destX, y + 1, par_collider))
						y++;
				}
			} else{ // DEFAULT MOVEMENT -- The entity doesn't move along slopes and should simply move to the target position.
				x = _destX;
			}
		}
	}
	
	// HANDLING VERTICAL COLLISION -- Slopes aren't considered for vertical movement, so the entity will simply
	// be moved pixel-by-pixel until they reach the collider that they are set to bump into. Otherwise, the
	// entity is just moved to their target position as it is free from obstructions.
	if (_deltaVspd != 0){
		var _destY = y + _deltaVspd;
		if (place_meeting(x, _destY, par_collider)){
			if (_destY > y) {stateFlags |= DNTT_GROUNDED;}
			
			// Move pixel-by-pixel until the collider is reached.
			var _signVspd = sign(vspd);
			while(!place_meeting(x, y + _signVspd, par_collider))
				y += _signVspd;
				
			// Clear whatever values were stored for the entity's vertical velocity.
			vspd = 0.0;
			vspdFraction = 0.0;
		} else{ // DEFAULT MOVEMENT -- No collision was found along the y-axis; move entity to target position.
			y = _destY;
		}
	}
}

#endregion

// VARIABLES FOR DEBUGGING PURPOSES
collisionMaskColor = HEX_WHITE;