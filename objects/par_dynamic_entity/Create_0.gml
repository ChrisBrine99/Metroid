#region Macros utilized by all dynamic entities

// Positions for the bits that toggle on and off these main entity "states" stored within the "stateFlags"
// variable found in each child of this object. These are unique to "par_dynamic_entity" and its children.
#macro	DESTRUCTIBLE			21
#macro	GROUNDED				22

// Simplified checks of each default "state" flags condensed into macros that explain what they functionally
// do. Otherwise, there would be a bunch of the same bitwise operations all over the code, which is messy.
#macro	DESTROY_WALL_COLLIDE	(stateFlags & (1 << DESTRUCTIBLE) != 0)
#macro	IS_GROUNDED				(stateFlags & (1 << GROUNDED) != 0)

// Flags for the Entity slope collision function to let it know which direction a slope is so the function
// can calculate collisions according to that direction.
#macro	SLOPE_UPWARD		   -1
#macro	SLOPE_DOWNWARD			1

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
curState	= NO_STATE;
lastState	= NO_STATE;
nextState	= NO_STATE;

// 32-bits that can each represent their own functionality within any children of this object. However, the 
// top eight bits are reserved for generic flags that are required for an entity to function properly.
stateFlags = (1 << ACTIVE);

// Variables for keeping track of and manipulating an audio component that can optionally be attached to an
// entity. The first variable stores the pointer to the attached component, whereas the last two variables
// allow the component to be offset from the entity's position based on their respective values.
audioComponent = noone;
audioOffsetX = 0;
audioOffsetY = 0;

// Much like above, this group of variables will keep track of and manipulate a component, but its focus is
// the optional light component that can be attached to an entity. The first variable stores the pointer,
// and the last two store the offset position to place the light at relative to the entity's position.
lightComponent = noone;
lightOffsetX = 0;
lightOffsetY = 0;

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
hAccel = 0.0;
vAccel = 0.0;
hAccelFactor = 1.0;
vAccelFactor = 1.0;

// The maximum possible horizontal movement speed, and the maximum falling speed OR vertical movement speed
// (This can change depending on the entity in question). Much like acceleration, the maximum velocity values
// allow for real-time adjustment of said values without having to overwrite those values.
maxHspd = 0.0;
maxVspd = 0.0;
maxHspdFactor = 1.0;
maxVspdFactor = 1.0;

// Variables that are responsible for storing the decimal values of the horizontal and vertical celocities,
// respectively. Once a whole number exists within these values, they will be parsed out and used for entity
// movement/collision detection; leaving the decimals within the respective values.
hspdFraction = 0.0;
vspdFraction = 0.0;

// The number of hitpoints the entity has currently, as well as the maximum possible value they can have. Once
// the entity's hitpoints reach or go below a value of zero, they will be destroyed at the start of the next 
// frame (If the flag for invulnerability isn't set to 1).
hitpoints = 0;
maxHitpoints = 0;

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
	stateFlags	   |= (1 << HIT_STUNNED);
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
		stateFlags |= (1 << DESTROYED);
		hitpoints	= 0;
	}
}

/// @description The default gravity function, which applies downward movement to the entity's vspd value until
/// the maximum vertical falling speed has been reached. Once the ground has been reached, the flag to signify
/// that state is flipped and the vspd value is reset to 0.
/// @param {Real}	maxFallSpeed
apply_gravity = function(_maxFallSpeed){
	// Always apply gravity on the Entity, which is cancelled out if they are on the ground. Otherwise, their
	// vspd will be constantly increased by their vertical acceleration until they hit their terminal velocity.
	vspd	   += get_vert_accel() * DELTA_TIME;
	if (vspd > _maxFallSpeed)
		vspd	= _maxFallSpeed;
	
	// Determine if the Entity is currently on the grounded or are airbourne; flipping their "grounded" state
	// flag to true or false while removing gravity's effect, respectively.
	var _onGround		= place_meeting(x, y + 1, par_collider);
	if (!_onGround){
		stateFlags	   &= ~(1 << GROUNDED);
	} else if (!IS_GROUNDED && vspd >= 0.0 && _onGround){
		stateFlags	   |= (1 << GROUNDED);
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
apply_frame_movement = function(_collisionFunction = NO_FUNCTION){
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
		_collisionFunction(_deltaHspd, _deltaVspd);
	} else if (_deltaHspd != 0 || _deltaVspd != 0){
		x += _deltaHspd;
		y += _deltaVspd;
	}
}

/// @description Checks for collision between the entity and the world's collision bounds. If no collision is
/// detected, the entity will be translated to their new position based on the hspd and vspd values provided
/// in the function's parameters.
/// @param {Real}	deltaHspd	Movement along the X-axis in whole pixels for the current frame.
/// @param {Real}	deltaVspd	Movement along the Y-axis in whole pixels for the current frame.
entity_world_collision = function(_deltaHspd, _deltaVspd){
	// Check horizontal collision only if the value of "_deltaHspd" is a value other than 0. Otherwise, checks
	// for collision on the x-axis would be pointless since there isn't any movement occurring.
	if (_deltaHspd != 0){
		// Store the destination position to avoid having to calculate it on every collision check. Then, check
		// to see if that destination position is blocked by a collider. If so, a horizontal collision process
		// will be processed.
		var _destX = x + _deltaHspd;
		if (place_meeting(_destX, y, par_collider)){
			// First, a check for a potential upward slope is processed prior to any horizontal movement
			// occurring. If there is, the Entity will be moved along it if allowed, and the main chunk of the
			// horizontal collision processing will occur if a collision is still occurring.
			entity_world_slope_collision(_destX, y, SLOPE_UPWARD, false);
			if (place_meeting(_destX, y, par_collider)){
				// Move pixel-by-pixel until the Entity is colliding with a collider at the NEXT pixel in the
				// direction of their current horizontal velocity.
				var _signHspd = sign(hspd);
				while(!place_meeting(x + _signHspd, y, par_collider))
					x += _signHspd;
				
				// If the Entity is destroyed by wall collisions, it will be destroyed here. Then, the function 
				// is exited early since the remaining code doesn't need to be processed for a new destroyed 
				// Entity. Otherwise, "_destX" is set to X to prevent further movement and "hspd" is set to 0.
				if (DESTROY_WALL_COLLIDE){
					stateFlags |= (1 << DESTROYED);
					return;
				}
				
				_destX		 = x;
				hspdFraction = 0.0;
				hspd		 = 0.0;
			}
		} else if (IS_GROUNDED){
			// If there is no horizontal collision, a check still needs to be made to see if there is a downward
			// slope instead. If there is, this function call will move the Entity properly as a result.
			entity_world_slope_collision(_destX, y + 1, SLOPE_DOWNWARD, true);
		}
		x = _destX;
	}
	
	// Check vertical collision only if the value of "_deltaVspd" is a value other than 0. Otherwise, checks
	// for collision on the y-axis would be pointless since there isn't any movement occurring.
	if (_deltaVspd != 0){
		// Store the destination position to avoid having to calculate it on every collision check. Then, check
		// to see if that destination position is blocked by a collider. If so, a vertical collision process
		// will be processed.
		var _destY = y + _deltaVspd;
		if (place_meeting(x, _destY, par_collider)){
			if (_destY > y) {stateFlags |= (1 << GROUNDED);}
			
			// Move pixel-by-pixel until the Entity is colliding with a collider at the NEXT pixel in the
			// direction of their current vertical velocity.
			var _signVspd = sign(_deltaVspd);
			while(!place_meeting(x, y + _signVspd, par_collider))
				y += _signVspd;
			
			// If the Entity is destroyed by wall collisions, it will be destroyed here. Then, the function is 
			// exited early since the remaining code doesn't need to be processed for a new destroyed Entity.
			// Otherwise, "_destY" is set to Y to prevent further movement and "vspd" is set to 0.
			if (DESTROY_WALL_COLLIDE){
				stateFlags |= (1 << DESTROYED);
				return;
			}
			
			_destY		 = y;
			vspdFraction = 0.0;
			vspd		 = 0.0;
		}
		y = _destY;
	}
}

/// @description Processes collision between a given Entity and sloped surfaces in the game world. It will move
/// stepwise (upward or downward depending on the direction that is set to be checked) on a per-pixel basis until
/// the Entity can no longer move up the slope. After that, a final collision check for the desired outcome 
/// occurs to see if the post-slope destination can be moved to.
/// @param {Real}	x				Destination x position for the Entity.
/// @param {Real}	y				Destination y position for the Entity.
/// @param {Real}	slopeDirection	Determines the "direction" of the slope (1 = downward slope, -1 = upward slope).
/// @param {Bool}	desiredOutcome	Keeps track of what the final "place_meeting" function should return for the slope to be traversable.
entity_world_slope_collision = function(_x, _y, _slopeDirection, _desiredOutcome){
	// Store the maximum possible slope based on the Entity's maximum horizontal velocity. Another local value
	// will be stored for the current pixel offset of the slope collision check.
	var _maxSlopeOffset = floor(maxHspd) * _slopeDirection;
	var _curSlopeOffset	= 0;
	
	// Loop and check pixel-by-pixel until the offset matches the maximum possible offset OR the desired outcome
	// for the collision was met prior to the final collision check. Either outcome will exit the loop.
	while(place_meeting(_x, _y + _curSlopeOffset, par_collider) != _desiredOutcome){
		_curSlopeOffset += _slopeDirection;
		if (_curSlopeOffset >= _maxSlopeOffset) {break;}
	}
	
	// Perform one last collision check to see if the desired outcome is returned. If not, no slope movement
	// is possible and the Entity will not be moved.
	if (place_meeting(_x, _y + _curSlopeOffset, par_collider) == _desiredOutcome)
		y += _curSlopeOffset;
}

#endregion

// VARIABLES FOR DEBUGGING PURPOSES
collisionMaskColor = HEX_WHITE;