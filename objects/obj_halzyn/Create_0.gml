#region Macro initialization

// Stores the coordinates (x, y) of the Halzyn's vulnerable collider relative to its own coordinates, as well 
// as the size (Both width and height) of said area. The ID for this collider is also stored since it is used
// during the transition between dormancy and attacking to disable vulnerability during the attacking states.
#macro	HLZN_COLLIDER_ID		0
#macro	HLZN_COLLIDER_X		   -6
#macro	HLZN_COLLIDER_Y		   -5
#macro	HLZN_COLLIDER_SIZE		12

// Macros that help determine how the Halzyn processes a vertical collision with the world during its attacking
// state. The top value determines the offset relative to its actual Y to perform the "place_meeting" collision
// checks, and the last macros determines how fast it'll shake back and forth when a collision occurs.
#macro	HLZN_YCOLLIDE_OFFSET   -4
#macro	YCOLLIDE_SHAKE_SPEED	1.5		

// Values for the damage the Halzyn can inflict on Samus while it is dormant (Flying in a "sine" pattern) state
// versus its attacking state, respectively.
#macro	HALZYN_BASE_DAMAGE		30
#macro	HALZYN_ATTACK_DAMAGE	50

// Macros that determine how the Halzyn moves during its dormant/default state. THe top value is how long in
// "unit frames" (60 units = 1 second) it will move along the x axis before it switches directions, and the
// bottom value determines how quick it will bob up and down along that horizontal path.
#macro	HMOVE_INTERVAL			150.0
#macro	VMOVE_INTERVAL			7.0

// Macros for various attack state checks/conditions. The first two values are the how close Samus needs to be
// to the Halzyn's left or right, and how far below she needs to be for it to try attacking her. The next three
// store durations of time (60.0 = 1 second) for various things related to attacking. THe final value is the
// speed it will shake back and forth at prior to dropping onto Samus.
#macro	ATTACK_X_BOUNDS			28
#macro	ATTACK_Y_BOUNDS			64
#macro	ATTACK_BEGIN_TIME		10.0
#macro	ATTACK_END_TIME			36.0
#macro	ATTACK_COOLDOWN_TIME	80.0
#macro	ATTACK_SHAKE_SPEED		2.0

// Stores the upward velocity the Halzyn will use to return to its pre-attack y position after an attack.
#macro	ATTACK_RETURN_VSPD	   -2.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum horizontal and vertical velocity for the Halzyn. Note that the maxVspd is utilized a bit
// different from a standard velocity value; being used as an amplitude for vertical movement, instead.
maxHspd = 1.0;
maxVspd = 24.0;

// Used during the Halzyn's attack to determine how fast it will accelerate towards the ground. It is much
// stronger than standard gravity (0.25 for Samus) as a result.
vAccel	= 1.25;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Halzyn will be able to take
// a massive sixteen hits before dying. Other beams and missiles will change the amount of hits needed.
maxHitpoints	= 16;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Halzyn. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= HALZYN_BASE_DAMAGE;
stunDuration	= 20;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.35;	// 35%
aeionDropChance		= 0.35;	// 35%
ammoDropChance		= 0.20;	// 20%

#endregion

#region Unique variable intializations

// Keeps track of the current direction of movement (-1 for left; +1 for right) and how long the Halzyn has
// been moving in that direction to determine when a flip should happen, respectively.
movement	= 0;
hFlipTimer	= 0.0;

// Variables that store the Halzyn's y position upon initialization so it can know where to flip its horizontal
// movement along the vertical "sine" path it takes, and for the Halzyn's y position along said path prior to
// it performing an attack, respectively.
startY		= 0;
preAttackY	= 0;

// 
attackTimer	= 0.0;
shakeTimer	= 0.0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Halzyn, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Halzyn. It sets its sprite, and sets it to be weak to all 
/// forms of weaponry. On top of that, the "wing" portions of its sprite have colliders applied to them that
/// nullify all projectile weapons; the center having its "weak point" collider.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_halzyn0, -1);
	object_add_light_component(x, y, 0, 4, 10, HEX_LIGHT_RED, 0.5);
	initialize_weak_to_all();
	
	// 
	create_weapon_collider(HLZN_COLLIDER_X, HLZN_COLLIDER_Y, HLZN_COLLIDER_SIZE, HLZN_COLLIDER_SIZE);
	create_weapon_collider(-14, -10, 8, 20, true);		// Left wing
	create_weapon_collider(6, -10, 8, 20, true);		// Right wing
	
	// Set the default values for the variables the Halzyn will utilize in its default state; randomly choosing
	// starting movement as either to the left or right, and storing the initial y position as the mid-point of
	// its normal movement (When "cos(.
	movement	= choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	hFlipTimer	= HMOVE_INTERVAL >> 1;
	startY		= y;
}

#endregion

#region Utility function initialization

/// @description 
/// @param {Real}	speed
halzyn_apply_shake = function(_speed){
	shakeTimer += DELTA_TIME;
	if (shakeTimer >= _speed){
		if (x == stunX) {x += choose(-1, 1);}
		else			{x	= stunX + sign(stunX - x);}
		shakeTimer -= _speed;
	}
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// 
	var _deltaTime = DELTA_TIME;
	
	// 
	if (attackTimer == ATTACK_COOLDOWN_TIME){
		// 
		var _playerX	= 0xFFFFFFFF;
		var _playerY	= 0xFFFFFFFF;
		var _movement	= 0;
		with(PLAYER){
			_playerX	= x;
			_playerY	= y;
			_movement	= (movement == 0) ? 0.25 : abs(movement);
		}
	
		// 
		if (abs(_playerX - x) <= ATTACK_X_BOUNDS * _movement && (_playerY - y) >= ATTACK_Y_BOUNDS){
			object_set_next_state(state_begin_attack);
			entity_set_sprite(spr_halzyn1, -1, 1.0, 0);
		
			// 
			edit_weapon_collider(0, -14, -9, 28, 20, true);
			instance_deactivate_object(colliderIDs[| 1]);
			instance_deactivate_object(colliderIDs[| 2]);
		
			stateFlags &= ~(1 << LOOP_ANIMATION);
			attackTimer = 0.0;
			stunX		= x;	// Borrow hitstun variable for attack beginning's shake effect.
			preAttackY	= y;	// Store pre-attack y position so the Halzyn knows where to return to after attacking.
			return;
		}
	} else{ // 
		attackTimer += _deltaTime;
		if (attackTimer > ATTACK_COOLDOWN_TIME)
			attackTimer = ATTACK_COOLDOWN_TIME;
	}
	
	// 
	hspd		= maxHspd * movement;
	hFlipTimer += _deltaTime;
	if (hFlipTimer >= HMOVE_INTERVAL){
		movement   *= -1;
		hFlipTimer  = 0.0;
	}
	
	// 
	direction  += VMOVE_INTERVAL * movement * _deltaTime;
	
	// 
	var _deltaHspd	= hspd * _deltaTime;
	_deltaHspd	   += hspdFraction;
	hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * sign(hspd));
	_deltaHspd	   -= hspdFraction;
	
	// 
	x  += _deltaHspd;
	y	= round(startY + (sin(degtorad(direction)) * maxVspd));
}

/// @description 
state_begin_attack = function(){
	// 
	var _imageIndex		= imageIndex;
	var _spriteLength	= spriteLength - 1;
	with(lightComponent) {strength = (1.0 - (_imageIndex / _spriteLength)) * 0.5;}
	
	// 
	if (_imageIndex < _spriteLength) {return;}
	var _deltaTime = DELTA_TIME;
	
	// 
	attackTimer += _deltaTime;
	if (attackTimer >= ATTACK_BEGIN_TIME){
		object_set_next_state(state_attack);
		x			= stunX;
		damage		= HALZYN_ATTACK_DAMAGE;
		attackTimer	= 0.0;
		shakeTimer	= 0.0;
		return;
	}
	
	// 
	halzyn_apply_shake(ATTACK_SHAKE_SPEED);
}

/// @description 
state_attack = function(){
	var _deltaTime = DELTA_TIME;
	
	// 
	vspd += vAccel * _deltaTime;
	if (vspd >= MAX_FALL_SPEED) {vspd = MAX_FALL_SPEED;}
	
	// 
	var _signVspd	= sign(vspd);
	var _deltaVspd	= vspd * _deltaTime;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * _signVspd);
	_deltaVspd	   -= vspdFraction;
	
	// 
	var _yy = y + HLZN_YCOLLIDE_OFFSET + _deltaVspd;
	if (place_meeting(x, _yy, par_collider)){
		while(!place_meeting(x, _yy, par_collider)){
			_yy += _signVspd;
			y	+= _signVspd;
		}
		object_set_next_state(state_end_attack);
		_deltaVspd	= 0.0;
		vspd		= 0.0;
	}
	y += _deltaVspd;
}

/// @description 
state_end_attack = function(){
	if (!CAN_LOOP_ANIMATION){
		if (imageIndex == 0){
			entity_set_sprite(spr_halzyn0, -1, 1.0, 0);
			
			// 
			edit_weapon_collider(
				HLZN_COLLIDER_ID, 
				HLZN_COLLIDER_X,	HLZN_COLLIDER_Y,	// Top-left position of the collider
				HLZN_COLLIDER_SIZE, HLZN_COLLIDER_SIZE,	// Width/height of the collider
				false
			);
			instance_activate_object(colliderIDs[| 1]);
			instance_activate_object(colliderIDs[| 2]);
			
			// 
			stateFlags |= (1 << LOOP_ANIMATION);
			damage		= HALZYN_BASE_DAMAGE;
			vspd		= ATTACK_RETURN_VSPD;
			attackTimer = 0.0;
			shakeTimer	= 0.0;
			return;
		}
		
		attackTimer += DELTA_TIME;
		if (attackTimer >= ATTACK_END_TIME){
			// 
			var _imageIndex		= imageIndex;
			var _spriteLength	= spriteLength - 1;
			with(lightComponent) {strength = ((_spriteLength - _imageIndex) / _spriteLength) * 0.5;}
			
			animSpeed = -1.0; // Reverses shell's closing animation to open it.
			return;
		}
		
		// 
		halzyn_apply_shake(YCOLLIDE_SHAKE_SPEED);
		return;
	}
	
	// 
	var _deltaVspd	= vspd * DELTA_TIME;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * sign(vspd));
	_deltaVspd	   -= vspdFraction;
	
	// 
	y			   += _deltaVspd;
	if (y <= preAttackY){
		object_set_next_state(state_default);
		y		= preAttackY;
		vspd	= 0.0;
	}
}

// Set the Halzyn to its default state upon creation.
initialize(state_default);

#endregion