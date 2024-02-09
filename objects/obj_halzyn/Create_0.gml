#region Macro initialization

// ------------------------------------------------------------------------------------------------------- //
//	Stores the coordinates (x, y) of the Halzyn's vulnerable collider relative to its own coordinates, as  //
//	well as the size (Both width and height) of said area. The ID for this collider is also stored since   //
//	it is used during the transition between dormancy and attacking to disable vulnerability during the	   //
//	attacking states.																					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_COLLIDER_ID		0
#macro	HLZN_COLLIDER_X		   -6
#macro	HLZN_COLLIDER_Y		   -5
#macro	HLZN_COLLIDER_SIZE		12

// ------------------------------------------------------------------------------------------------------- //
//	Macros that help determine how the Halzyn processes a vertical collision with the world during its	   //
//	attacking state. The top value determines the offset relative to its actual Y to perform the		   //
//	"place_meeting" collision checks, and the last macros determines how fast it'll shake back and forth   //
//	when a collision occurs.																			   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_YCOLLIDE_OFFSET   -4
#macro	HLZN_YCOLL_SHAKE_SPEED	1.5

// ------------------------------------------------------------------------------------------------------- //
//	Values for the damage the Halzyn can inflict on Samus while it is dormant (Flying in a "sine" pattern) //
//	state versus its attacking state, respectively.														   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_BASE_DAMAGE		30
#macro	HLZN_ATTACK_DAMAGE		50

// ------------------------------------------------------------------------------------------------------- //
//	Macros that determine how the Halzyn moves during its dormant/default state. THe top value is how long //
//	in "unit frames" (60 units = 1 second) it will move along the x axis before it switches directions,    //
//	and the bottom value determines how quick it will bob up and down along that horizontal path.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_HMOVE_INTERVAL		150.0
#macro	HLZN_VMOVE_INTERVAL		7.0

// ------------------------------------------------------------------------------------------------------- //
//	Macros for various attack state checks/conditions. The first two values are the how close Samus needs  //
//	to be to the Halzyn's left or right, and how far below she needs to be for it to try attacking her.	   // 
//	The next three store durations of time (60.0 = 1 second) for various things related to attacking. The  //
//	final value is the speed it will shake back and forth at prior to dropping onto Samus.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_ATTACK_XBOUNDS		38
#macro	HLZN_ATTACK_YBOUNDS		56
#macro	HLZN_ATK_BEGIN_TIME		8.0
#macro	HLZN_ATK_END_TIME		36.0
#macro	HLZN_ATK_COOLDOWN_TIME	80.0
#macro	HLZN_ATK_SHAKE_SPEED	2.0

// ------------------------------------------------------------------------------------------------------- //
//	Stores the upward velocity the Halzyn will use to return to its pre-attack y position after an attack. //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_ATK_RETURN_VSPD   -2.0

// ------------------------------------------------------------------------------------------------------- //
//	Determines the maximum downward velocity the Halzyn can move at when attacking.						   //
// ------------------------------------------------------------------------------------------------------- //

#macro	HLZN_MAX_FALL_SPEED		9.0

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
damage			= HLZN_BASE_DAMAGE;
stunDuration	= 20;

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

// Timer that is used during Halzyn's various attacking states.
attackTimer	= 0.0;

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
	
	// Set up weakness flags such that the Halzyn is weak to every type of weapon Samus can utilize.
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
	
	// Set the rates for item drops if the Halzyn is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 20;
	dropChances[ENMY_LGENERGY_DROP]		= 20;
	dropChances[ENMY_SMMISSILE_DROP]	= 5;
	dropChances[ENMY_LGMISSILE_DROP]	= 10;
	dropChances[ENMY_AEION_DROP]		= 15;
	dropChances[ENMY_POWBOMB_DROP]		= 0;
	
	// The Halzyn is unique in that is has two invulnerable colliders and then a smaller collider between the
	// two that is vulnerable to weaponry. The first collider will also act as the singular invulnerable area
	// when the Halzyn is attacking since it can't be damaged during said state.
	create_weapon_collider(HLZN_COLLIDER_X, HLZN_COLLIDER_Y, HLZN_COLLIDER_SIZE, HLZN_COLLIDER_SIZE);
	create_weapon_collider(-14, -10, 8, 20, true);		// Left wing
	create_weapon_collider(6, -10, 8, 20, true);		// Right wing
	
	// Set the default values for the variables the Halzyn will utilize in its default state; randomly choosing
	// starting movement as either to the left or right, and storing the initial y position as the mid-point of
	// its normal movement (When direction is ~0.0 or ~180.0).
	movement	= choose(MOVE_DIR_LEFT, MOVE_DIR_RIGHT);
	hFlipTimer	= HLZN_HMOVE_INTERVAL * 2.0;
	startY		= y;
}

#endregion

#region State function initialization

/// @description The Halzyn's default/dormant state; where it will move horizontally in a repeating pattern
/// that is offset vertically in a sinusoidal movement pattern. During this state the Halzyn will also check 
/// to see is Samus is near enough for it to attempt to attack her.
state_default = function(){
	// Cache the current value for delta time since it is utilized multiple times throughout the state.
	var _deltaTime = DELTA_TIME;
	
	// Only attempt to check if Samus should be attacked or not if the attack timer is equal to the Halzyn's
	// cooldown time for attacks. This is already the case for the Halzyn's first attack, and the timer will
	// be incremented to reach that cooldown time for each attack afterward.
	if (attackTimer == HLZN_ATK_COOLDOWN_TIME){
		// The player's current coordinates and movenent direction are required for the Halzyn to determine
		// if it should attack her and is even able to.
		var _playerX	= 0xFFFFFFFF;
		var _playerY	= 0xFFFFFFFF;
		var _movement	= 0;
		with(PLAYER){
			_playerX	= x;
			_playerY	= y;
			_movement	= (movement == 0) ? 0.25 : abs(movement);
		}
	
		// Compare the coordinates of Samus against the coordinates of the Halzyn (The x axis bounds are 
		// modified based on player's movement direction). If the checks pass the Halzyn will prep itself
		// for attack.
		if (abs(_playerX - x) <= HLZN_ATTACK_XBOUNDS * _movement && (_playerY - y) >= HLZN_ATTACK_YBOUNDS){
			object_set_next_state(state_begin_attack);
			entity_set_sprite(spr_halzyn1, -1, 1.0, 0);
		
			// Deactivate the colliders that represent the Halzyn's wings--which are immune to weaponry--and
			// edit the vulnerable collider to cover the entirety of the Halzyn while also toggling it to be
			// invulnerable temporarily.
			edit_weapon_collider(0, -14, -9, 28, 20, true);
			instance_deactivate_object(colliderIDs[| 1]);
			instance_deactivate_object(colliderIDs[| 2]);
			
			// Stop the Halzyn from looping any animations during its attacking states; reset the main attack
			// timer to 0 as well.
			stateFlags &= ~ENTT_LOOP_ANIM;
			attackTimer = 0.0;
			shiftBaseX	= x;
			preAttackY	= y;	// Store pre-attack y position so the Halzyn knows where to return to after attacking.
			return;
		}
	} else{ // Incrementing "attackTimer" until it hits the time required for attacking to be "out of cooldown".
		attackTimer += _deltaTime;
		if (attackTimer > HLZN_ATK_COOLDOWN_TIME)
			attackTimer = HLZN_ATK_COOLDOWN_TIME;
	}
	
	// Handling horizontal movement, which requires the incrementing of a timer that determines when the 
	// Halzyn can flip its movement along the x axis.
	hspd		= maxHspd * movement;
	hFlipTimer += _deltaTime;
	if (hFlipTimer >= HLZN_HMOVE_INTERVAL){
		hFlipTimer -= HLZN_HMOVE_INTERVAL;
		movement   *= -1;
	}
	
	// Updating the "direction" of the Halzyn, which helps determine its vertical position for the frame.
	direction  += HLZN_VMOVE_INTERVAL * movement * _deltaTime;
	
	// Removing fractional values from the Halzyn's hspd value; storing those fractional values into a buffer
	// variable until a whole number can be parsed out of that variable.
	var _deltaHspd	= hspd * _deltaTime;
	_deltaHspd	   += hspdFraction;
	hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * sign(hspd));
	_deltaHspd	   -= hspdFraction;
	
	// Finally, the Halzyn's position will be updated using the current whole number for its hspd on the x
	// axis and its current direction relative to the value found in "maxVspd" and its "startY" position, 
	// which was determined at initialization.
	x  += _deltaHspd;
	y	= round(startY + (sin(degtorad(direction)) * maxVspd));
}

/// @description During this state, the Halzyn will close its shell in order to drop down towards Samus. It
/// will first animate to reach its "closed shell" state before pausing at the final frame of animation. Then,
/// it will wait for a short interval of time; shaking left and right during that waiting period.Finally, it 
/// will switch into its main attack state.
state_begin_attack = function(){
	// Slowly dim the light based on the current frame of animation, so it matches the Halzyn's eye closing
	// during said animation. The final frame of animation sets the strength to 0 so the light isn't visible
	// during the attacking state.
	var _imageIndex		= imageIndex;
	var _spriteLength	= spriteLength - 1;
	//with(lightComponent) {strength = (1.0 - (_imageIndex / _spriteLength)) * 0.5;}
	
	// Don't allow the state to process anything else until the Halzyn has reached the final frame in the
	// "begin attack" animation.
	if (_imageIndex < _spriteLength) {return;}
	var _deltaTime = DELTA_TIME;
	
	// Increment the timer until it reaches or surpasses a value of 10.0 units (60.0 units = 1 second). Once
	// that value is met, the Halzyn will be set up to execute its main attack state.
	attackTimer += _deltaTime;
	if (attackTimer >= HLZN_ATK_BEGIN_TIME){
		object_set_next_state(state_attack);
		x			= shiftBaseX;
		damage		= HLZN_ATTACK_DAMAGE;	// Increases Halzyn's damage output during attack.
		attackTimer	= 0.0;
		return;
	}
	
	// Shake the Halzyn left and right at a speed of roughly 1/30th of a second.
	apply_horizontal_shift(HLZN_ATK_SHAKE_SPEED);
}

/// @description The Halzyn's main attack state, where it will drop downward until it collides with the floor
/// ("Colliding" in this case meaning slighting into the floor by ~4 pixels). Once in the floor, it will
/// immediately transition into its "end attack" state, which handles returning to the air.
state_attack = function(){
	var _deltaTime = DELTA_TIME; // Store value for delta time as it is used multiple times in the state.
	
	// Horizontal movement isn't needed for the frame, so only update vertical movement. Once the Halzyn's
	// vspd reaches its "max" (Which is borrowed from obj_player), it will remain at that speed.
	vspd += vAccel * _deltaTime;
	if (vspd >= HLZN_MAX_FALL_SPEED) 
		vspd = HLZN_MAX_FALL_SPEED;
	
	// Removing fractional values from the Halzyn's vspd value; storing those fractional values into a buffer
	// variable until a whole number can be parsed out of that variable.
	var _signVspd	= sign(vspd);
	var _deltaVspd	= vspd * _deltaTime;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * _signVspd);
	_deltaVspd	   -= vspdFraction;
	
	// Finally, perform a vertical collision check against the room collision; shifted ~4 pixels up from where
	// the Halzyn actually is so it will end up "in the ground" once a collision actually occurs. If a collision
	// DOES happen, the Halzyn is immediately transitioned into its "end attack" state.
	var _yy = y + _deltaVspd;
	if (place_meeting(x, _yy, par_collider)){
		_yy		   += HLZN_YCOLLIDE_OFFSET;	// Offset so Halzyn crashes into the ground upon collision.
		while(!place_meeting(x, _yy, par_collider)) 
			_yy += _signVspd;
		object_set_next_state(state_end_attack);
		y			= _yy - HLZN_YCOLLIDE_OFFSET;
		vspd		= 0.0;
		return;
	}
	y += _deltaVspd;
}

/// @description The "post attack" state that the Halzyn enters as soon as it collides with the ground in its
/// main attack state. It starts by remaining in the ground for a set interval of time before it resets itself
/// back to the position is was at prior to executing an attack.
state_end_attack = function(){
	if (!ENTT_CAN_LOOP_ANIM){
		// Begin the Halzyn's ascent back to where it was during its default/dormant state only once its shell
		// opening animation has been completed (The animation is just the attack begin animation in reverse,
		// so frame 0 is the "end" of the animation, in this case).
		if (imageIndex == 0){
			entity_set_sprite(spr_halzyn0, -1, 1.0, 0);
			
			// Reset the middle collide back to being the middle collider; shrinking and repositioning it to
			// where it was initially while also allowing weaponry to damage it once again. The wing colliders
			// are also reactivated.
			edit_weapon_collider(
				HLZN_COLLIDER_ID, 
				HLZN_COLLIDER_X,	HLZN_COLLIDER_Y,	// Top-left position of the collider
				HLZN_COLLIDER_SIZE, HLZN_COLLIDER_SIZE,	// Width/height of the collider
				false
			);
			instance_activate_object(colliderIDs[| 1]);
			instance_activate_object(colliderIDs[| 2]);
			
			// ALlow the Halzyn to loop its sprite animation once again; return its damage back to normal; set
			// its vspd to its "rising" velocity; and clear out the attack state's various timers.
			stateFlags |= ENTT_LOOP_ANIM;
			damage		= HLZN_BASE_DAMAGE;
			vspd		= HLZN_ATK_RETURN_VSPD;
			attackTimer = 0.0;
			return;
		}
		
		attackTimer += DELTA_TIME;
		if (attackTimer >= HLZN_ATK_END_TIME){
			animSpeed = -1.0; // Reverses shell's closing animation to open it.
			return;
		}
		
		// Shake the halzyn left and right to sell the impact it made with the floor because of its "weight".
		apply_horizontal_shift(HLZN_YCOLL_SHAKE_SPEED);
		return; // Don't allow movement until the Halzyn has finished "colliding" with the ground.
	}
	
	// Removing fractional values from the Halzyn's vspd value; storing those fractional values into a buffer
	// variable until a whole number can be parsed out of that variable.
	var _deltaVspd	= vspd * DELTA_TIME;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * sign(vspd));
	_deltaVspd	   -= vspdFraction;
	if (_deltaVspd == 0) {return;}	// Don't bother updating position if delta vspd isn't large enough.
	
	// Update the vertial position of the Halzyn and then check to see if it has reached or gone beyond the
	// vertical position it was at when it began attacking. If it is, the Halzyn's y position is set to that
	// value and the Halzyn is returned to its default state.
	y += _deltaVspd;
	if (y <= preAttackY){
		object_set_next_state(state_default);
		y		= preAttackY;
		vspd	= 0.0;
	}
}

#endregion

// Set the Halzyn to its default state upon creation.
initialize(state_default);