#region Macros utilized by all dynamic entities

// Positions for the bits that toggle on and off these main entity "states" stored within the "stateFlags"
// variable found in each child of this object. These are unique to "par_dynamic_entity" and its children.
#macro	USE_SLOPES				23
#macro	DESTRUCTIBLE			24
#macro	GROUNDED				25
#macro	HIT_STUNNED				26

// Simplified checks of each default "state" flags condensed into macros that explain what they functionally
// do. Otherwise, there would be a bunch of the same bitwise operations all over the code, which is messy.
#macro	CAN_USE_SLOPES			(stateFlags & (1 << USE_SLOPES) != 0)
#macro	DESTROY_WALL_COLLIDE	(stateFlags & (1 << DESTRUCTIBLE) != 0)
#macro	IS_GROUNDED				(stateFlags & (1 << GROUNDED) != 0)
#macro	IS_HIT_STUNNED			(stateFlags & (1 << HIT_STUNNED) != 0)

#endregion

#region Editing default variables, initializing unique variables, and other important initializations

// Edit some of the object's default variables before any initialization of unique variables occurs.
direction = 0;
sprite_index = NO_SPRITE;
image_index = 0;
image_speed = 0;
visible = false;

// The three state variables, which will store the currently execution state function, the previous state
// state function that was in use, and the next available state function to swap too at the beginning of the
// next frame (The state won't change whenever "curState" and "nextState" store the same function pointer).
curState = NO_STATE;
lastState = NO_STATE;
nextState = NO_STATE;

// 32-bits that can each represent their own functionality within any children of this object. However, the 
// top eight bits are reserved for generic flags that are required for an entity to function properly.
stateFlags = 0;

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

// 
interactComponent = noone;

// Variables for animating the current sprite appliex to an entity. They replace the standard built-in animation
// variables like "image_speed" and "image_index" to allow for frame-independent animations. The speed of the
// animation can be manipulated further by changing the value of "animSpeed". Finally, the loop offset determines
// which frame of animation will be the start of the animation; allowing for introduction frames if necessary.
imageIndex = 0;
animSpeed = 0;
spriteLength = 0;
spriteSpeed = 0;
loopOffset = 0;

// The current values for the horiztonal and vertical velocities of the entity, respectively. Regardless of
// these values, they will always allow for frame-independent physics and whole-number movement when paired
// with the "apply_frame_movement" function found in this parent object.
hspd = 0;
vspd = 0;

// The current horizontal and vertical acceleration values for the entity, as well as their factors to allow
// real-time adjustments to their values without actually overwriting those values.
hAccel = 0;
vAccel = 0;
hAccelFactor = 1;
vAccelFactor = 1;

// The maximum possible horizontal movement speed, and the maximum falling speed OR vertical movement speed
// (This can change depending on the entity in question). Much like acceleration, the maximum velocity values
// allow for real-time adjustment of said values without having to overwrite those values.
maxHspd = 0;
maxVspd = 0;
maxHspdFactor = 1;
maxVspdFactor = 1;

// Variables that are responsible for storing the decimal values of the horizontal and vertical celocities,
// respectively. Once a whole number exists within these values, they will be parsed out and used for entity
// movement/collision detection; leaving the decimals within the respective values.
hspdFraction = 0;
vspdFraction = 0;

// The number of hitpoints the entity has currently, as well as the maximum possible value they can have. Once
// the entity's hitpoints reach or go below a value of zero, they will be destroyed at the start of the next 
// frame (If the flag for invulnerability isn't set to 1).
hitpoints = 0;
maxHitpoints = 0;

// 
hitstunTimer = 0;
hitstunLength = 0;

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
/// @param {Function}		state	The function to use for this entity's initial state.
initialize = function(_state){
	object_set_next_state(_state);
	visible = true;
}

/// @description 
/// @param {Real}	duration
/// @param {Real}	damage
entity_apply_hitstun = function(_duration, _damage = 0){
	if (IS_HIT_STUNNED) {return;}
	object_set_next_state(state_hitstun);
	update_hitpoints(-_damage);
	stateFlags |= (1 << HIT_STUNNED);
	hitstunLength = _duration;
}

/// @description A simple function that applies a modifier value to the entity's current hitpoints. It will
/// automatically prevent the value from exceeding whatever the maximum hitpoints has been set to for the
/// entity, while also flagging their destruction if they go below zero hitpoints.
/// @param {Real}	modifier	The value that will be subtracted (Argument is negative) or added (Argument is positive) to the entity's hitpoints.
update_hitpoints = function(_modifier){
	hitpoints += _modifier;
	if (hitpoints > maxHitpoints){ // Prevent exceeding maximum possible hitpoints.
		hitpoints = maxHitpoints;
	} else if (hitpoints <= 0){ // Set the entity to "destroyed" by flipping that respective flag.
		object_set_next_state(NO_STATE);
		stateFlags |= (1 << DESTROYED);
		hitpoints = 0;
	}
}

/// @description The default gravity function, which applies downward movement to the entity's vspd value until
/// the maximum vertical falling speed has been reached. Once the ground has been reached, the flag to signify
/// that state is flipped and the vspd value is reset to 0.
/// @param {Real}	maxFallSpeed
apply_gravity = function(_maxFallSpeed){
	var _isOnGround = place_meeting(x, y + 1, par_collider);
	if (!_isOnGround){
		stateFlags &= ~(1 << GROUNDED);
		vspd += get_vert_accel() * DELTA_TIME;
		if (vspd > _maxFallSpeed) {vspd = _maxFallSpeed;}
	} else if (_isOnGround && vspd >= 0 && !IS_GROUNDED){
		stateFlags |= (1 << GROUNDED);
		vspdFraction = 0;
		vspd = 0;
	}
}

/// @description Applies the current value for delta time to the entity's horizontal and vertical movement
/// values so they accurate simulate 60fps physics with an unlocked frame rate. After that is performed, an
/// optional collision function can be called upon with the non-fractional movement values.
/// 
/// NOTE -- These functions must include two arguments for the "deltaHspd" and "deltaVspd" values calculated
///			within this function or else the game will likely crash.
/// 
/// @param {Function}	collisionFunction
apply_frame_movement = function(_collisionFunction = NO_FUNCTION){
	// Step One: Apply the current delta time for the frame to the current horizontal and vertical movement
	// values, which are stored in pixels per 1/60th of a real-world second before this calculation.
	var _deltaTime = DELTA_TIME;
	var _deltaHspd = hspd * _deltaTime;
	var _deltaVspd = vspd * _deltaTime;
	
	// Step Two: Apply the previously stored fractional values for the horizontal and vertical movement values.
	_deltaHspd += hspdFraction;
	_deltaVspd += vspdFraction;
	
	// Step Three: Calcuate the new fractional values after the previous values have been added to the newly
	// calculated delta values for the frame; resulting in both being combined and stored in the horizontal
	// and vertical fractional value storage variables, respectively.
	hspdFraction = _deltaHspd - (floor(abs(_deltaHspd)) * sign(_deltaHspd));
	vspdFraction = _deltaVspd - (floor(abs(_deltaVspd)) * sign(_deltaVspd));
	
	// Step Four: Remove the fraction values from the "_deltaHspd" and "_deltaVspd" values, respectively;
	// leaving only the whole number for use in the entity's world collision function.
	_deltaHspd -= hspdFraction;
	_deltaVspd -= vspdFraction;
	
	// Step Five: call the collision function that was specified (If one was actually provided when this
	// function was called in the code; the default is no function at all) to handle collision with the world
	// using the calculated delta values for the entity's velocities.
	if (_collisionFunction != NO_FUNCTION && (_deltaHspd != 0 || _deltaVspd != 0)) {_collisionFunction(_deltaHspd, _deltaVspd);}
}

/// @description Checks for collision between the entity and the world's collision bounds. If no collision is
/// detected, the entity will be translated to their new position based on the hspd and vspd values provided
/// in the function's parameters.
/// @param {Real}	deltaHspd	Movement along the X-axis in whole pixels for the current frame.
/// @param {Real}	deltaVspd	Movement along the Y-axis in whole pixels for the current frame.
entity_world_collision = function(_deltaHspd, _deltaVspd){
	// First, horizontal collision is checked. Along with calculating collision to the right and left, sloped
	// collisions will also be considered in order to allow seamless movement along slopes that have an angle
	// of 45 degrees or shallower.
	var _yOffset = 0;
	var _maxSlope = floor(maxHspd);
	if (place_meeting(x + _deltaHspd, y, par_collider)){
		// Before checking horizontal collision, a check for a vertical slope collision is performed first
		// if the entity is allowed to move along slopes. If so, it will offset the entity's y position based 
		// on the slope of the collider in question if that slope isn't too steep.
		if (USE_SLOPES){
			while(place_meeting(x + _deltaHspd, y - _yOffset, par_collider) && _yOffset < _maxSlope) {_yOffset++;}
			if (!place_meeting(x + _deltaHspd, y - _yOffset, par_collider)) {y -= _yOffset;}
		}
		
		// After checking and potentially applying upward slope movement, the standard horizontal collision is
		// performed; moving the entity pixel-by-pixel until they perfectly collide with the world.
		if (place_meeting(x + _deltaHspd, y, par_collider)){
			var _hspdSign = sign(hspd);
			while(!place_meeting(x + _hspdSign, y, par_collider)) {x += _hspdSign;}
			stateFlags |= (DESTROY_WALL_COLLIDE << DESTROYED);
			_deltaHspd = 0; // Nullifies horizontal movement for the frame of collision.
			hspd = 0;
		}
	} else if (IS_GROUNDED && USE_SLOPES){
		// Only when on the ground, downward sloped floor movement is checked and/or calculated. If the slope
		// is steeper than 45 degrees, the entity will not move along the slope.
		while(!place_meeting(x + _deltaHspd, y + 1, par_collider) && _yOffset < _maxSlope) {_yOffset++;}
		if (place_meeting(x + _deltaHspd, y + _yOffset, par_collider)) {y += _yOffset - 1;}
	}
	x += _deltaHspd; // Apply the value for horizontal movement to the entity's current x position.
	
	// Next, vertical collision is checked. This is much simpler than horizontal collision because there is no
	// need to consider sloped surfaces when colliding with the top or bottom bounds of the entity's collision
	// box.
	if (place_meeting(x, y + _deltaVspd, par_collider)){
		var _vspdSign = sign(vspd);
		while(!place_meeting(x, y + _vspdSign, par_collider)) {y += _vspdSign;}
		stateFlags |= (DESTROY_WALL_COLLIDE << DESTROYED);
		_deltaVspd = 0; // Nullifies vertical movement for the frame of collision.
		vspd = 0;
	}
	y += _deltaVspd;
}

#endregion

#region States for use in all children objects of par_dynamic_entity

/// @description 
state_hitstun = function(){
	// 
	hitstunTimer += DELTA_TIME;
	if (hitstunTimer >= hitstunLength){
		stateFlags &= ~(1 << HIT_STUNNED);
		stateFlags |= (1 << DRAW_SPRITE);
		hitstunTimer = 0;
		return;
	}
	
	// 
	if (CAN_DRAW_SPRITE)	{stateFlags &= ~(1 << DRAW_SPRITE);}
	else					{stateFlags |= (1 << DRAW_SPRITE);}
}

#endregion

// VARIABLES FOR DEBUGGING PURPOSES
collisionMaskColor = HEX_WHITE;