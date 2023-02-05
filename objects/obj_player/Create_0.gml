#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Samus's physics characteristics; her maximum walking speed (maxHspd), as well as her acceleration on that
// axis, and jumping power (maxVspd), as well as her acceleration vertically (gravity).
maxHspd = 2.2;
maxVspd = BASE_JUMP_HEIGHT;
hAccel = 0.3;
vAccel = 0.25;

// Samus's ability to take damage (Known as her "energy" in all official games) from hazards. The higher the
// value, the more she will be able to endure before dying. Starts at a value of 99 and expands by 100 points
// for every "Energy Tank" she collects in the game world.
maxHitpoints = 99;
hitpoints = maxHitpoints;

#endregion

#region Initializing unique variables

// Two variables storing the boolean values for the player's inputs; for the current frame and previous frame,
// respectively. Key presses, releases, and holds can all be determined based on the values in these variables
// for any game frame.
inputFlags = 0;
prevInputFlags = 0;

// Variables to represent each of Samus's animations based on the suit she currently has equipped. They start
// with the Power Suit by default, and then are overwritten by the Varia Suit followed by the Gravity Suit when
// each of those are collected by the player.
introSprite =		spr_power_stand0;	// Intro sprite (Facing forward)
standSpriteFw =		spr_power_stand1;	// Standing sprites
standSpriteUp =		spr_power_stand2;
walkSpriteFw =		spr_power_walk0;	// Walking sprites
walkSpriteFwExt =	spr_power_walk1;
walkSpriteUp =		spr_power_walk2;
jumpSpriteFw =		spr_power_jump1;	// Jumping sprites
jumpSpriteUp =		spr_power_jump2;
jumpSpriteDown =	spr_power_jump3;
jumpSpriteSpin =	spr_power_jump0;
crouchSprite =		spr_power_crouch0;	// Crouching sprite
morphballSprite =	spr_power_mball0;	// Morphball sprites
ballEnterSprite =	spr_power_mball1;

// Collision masks for some of Samus's states and substates. They determine that area that will be used to
// handle collisions between her, the world, hazards, and other entities. Their heights and vertical positions
// may differ, but their widths are always the same at 10 pixels to avoid bugged collisions.
standingMask =		spr_power_stand1;
jumpingMask =		spr_power_jump1;
crouchingMask =		spr_power_crouch0;
morphballMask =		spr_power_mball0;

// 
reserveHitpoints = 0;
maxReserveHitpoints = 0;
energyTankPieces = 0;
curAeion = 0;
maxAeion = 0;
numMissiles = 0;
maxMissiles = 0;
numPowerBombs = 0;
maxPowerBombs = 0;

// Timer variables that will count upwards until a certain threshold has been met. After which, an animation
// will conclude, Samus will lower her arm cannon, her main state will change, or her substate will change;
// to name a few possibilities.
standingTimer = 0;
aimReturnTimer = 0;
aimSwitchTimer = 0;
mBallEnterTimer = 0;
jumpStartTimer = 0;

// Keeps track of how high the morphball will bounce relative to its falling speed when it initially hits the
// ground. A high enough value will make the morphball bounce into the air again.
vspdRecoil = 0;

// Variables for Samus's strandard bombs; determining how fast she can deploy them, how many she can deploy at
// any given time, the power of the blast that allows for bomb jumping, and a variable to track the explosion
// that hit her so it doesn't constantly collide with it every frame; skewing the true vertical velocity if
// this was the case.
bombDropTimer = 0;
bombJumpVspd = -4;
bombExplodeID = noone;

//
armCannon = instance_create_struct(obj_arm_cannon);
armCannon.pID = id;

// 
curWeapon = (1 << POWER_BEAM);

// 
chargeTimer = 0;

// 
tapFireRate = 3;
holdFireRate = 16;
fireRateTimer = 16;

// 
liquidData = {
	// 
	liquidID : noone,
	
	// 
	maxHspdPenalty : 0,
	maxVspdPenalty : 0,
	hAccelPenalty : 0,
	vAccelPenalty : 0,
	
	// 
	damage : 0,
	damageInterval : 0,
	damageTimer : 0,
};

#endregion

#region Utility function initialzations

/// @description Handles input processing for the player object by polling the active input device. Unique
/// to the gamepad is analog stick movement, which uses unique variables since they can't feasibly be stored 
/// in the "inputFlags" variable.
process_input = function(){
	prevInputFlags = inputFlags;
	if (GAMEPAD_IS_ACTIVE){ // Getting input from the connected gamepad
		
	} else{ // Getting input from the keyboard (Default input device)
		inputFlags = 
			(keyboard_check(KEYCODE_GAME_RIGHT)		<<	MOVE_RIGHT) |
			(keyboard_check(KEYCODE_GAME_LEFT)		<<	MOVE_LEFT) |
			(keyboard_check(KEYCODE_GAME_UP)		<<	AIM_UP) |
			(keyboard_check(KEYCODE_GAME_DOWN)		<<	AIM_DOWN) |
			(keyboard_check(KEYCODE_JUMP)			<<	JUMP) |
			(keyboard_check(KEYCODE_USE_WEAPON)		<<	USE_WEAPON);
	}
}

/// @description Since this piece of code needs to be utilized for two seperate scenarios in the crouching
/// state, it's been outlined and placed into its own function to simplify the crouching state's code; 
/// improving code readability.
crouch_to_standing = function(){
	mask_index = standingMask; // Swap masks for accurate collision processing.
	if (!place_meeting(x, y, par_collider)){
		object_set_next_state(state_default);
		entity_set_sprite(standSpriteFw, standingMask);
		stateFlags &= ~(1 << CROUCHING);
		standingTimer = 0;
		return; // Exit before mask can be reset by the code found below.
	}
	mask_index = crouchingMask; // Return to original mask if collision check returns "true".
}

/// @description Identical to the function above, it will transition Samus between two ground-based states 
/// where her collision bounds differ, but this function will be for changing between her morphball mode and
/// her standard form, respectively.
morphball_to_crouch = function(){
	mask_index = crouchingMask; // Swap masks for accurate collision processing.
	if (!place_meeting(x, y, par_collider)){
		object_set_next_state(state_enter_morphball);
		entity_set_sprite(ballEnterSprite, morphballMask);
		vspdRecoil = 0;			// Reset variables related to the morphball to default values.
		bombDropTimer = 0;
		bombExplodeID = noone;
		return; // Exit before mask can be reset by the code found below.
	}
	mask_index = morphballMask; // Return to original mask if collision check returns "true".
}

/// @description Processes the logic for Samus's arm cannon; her main source of defending herself while in her
/// power suit form. It will count down timers that determine a beam's fire rate both when tapping the fire input
/// and holding it if the charge beam hasn't been unlocked. Other than that, it will create the necessary projectile
/// for whatever one Samus has currently active, which can any of the following: Power Beam, Ice Beam, Tesla
/// Beam, Plasma Beam, Missile, Ice Missile, and Shock Missile.
/// @param {Real} movement	A value of 1, 0, or -1 depending on the state of Samus's horizontal movement inputs.
update_arm_cannon = function(_movement){
	// 
	var _isAiming = IS_AIMING;
	var _useHeld = IS_USE_HELD;
	var _usePressed = IS_USE_PRESSED;
	var _useReleased = IS_USE_RELEASED;
	if ((_useHeld || _usePressed) && !_isAiming){
		stateFlags &= ~((1 << JUMP_SPIN) | (1 << JUMP_ATTACK)); // Flip flags to 0 no matter what.
		stateFlags |= (1 << AIMING_FRONT);
		aimReturnTimer = 0;
	}
	
	// 
	var _isCharged = false;
	if (!IS_MISSILE_EQUIPPED){
		var _chargeBeam = true;//event_get_flag(FLAG_CHARGE_BEAM);
		if (_useHeld && _chargeBeam){
			chargeTimer += DELTA_TIME;
			if (chargeTimer >= MIN_CHARGE_TIME) {chargeTimer = MIN_CHARGE_TIME;}
		
			// 
			if (chargeTimer >= tapFireRate){
				aimReturnTimer = 0;
				return;
			}
		}
		
		// 
		_isCharged = (_useReleased && _chargeBeam && chargeTimer == MIN_CHARGE_TIME);
		if (_useReleased) {chargeTimer = 0;}
	}
	
	// 
	var _holdingFire = (_useHeld && !_isCharged && fireRateTimer == holdFireRate);
	var _tappingFire = (_usePressed && fireRateTimer >= tapFireRate);
	var _chargeFire = (_useReleased && _isCharged);
	if (_holdingFire || _tappingFire || _chargeFire){
		create_projectile(_isCharged);
		fireRateTimer = _holdingFire ? tapFireRate : 0;
		aimReturnTimer = 0;
	}
	
	// Resetting the fire rate timer whenever a projectile has been shot; preventing the player from firing 
	// another until this timer has reached its "hold" threshold (If the charge beam isn't unlocked yet).
	// Tapping the fire button will yield a much faster fire rate than this method.
	if (fireRateTimer < holdFireRate){
		fireRateTimer += DELTA_TIME;
		if (fireRateTimer >= holdFireRate) {fireRateTimer = holdFireRate;}
	}
	
	// Tracking time until the "aimReturnTimer" surpasses the required value, which will then make Samus lower
	// her arm cannon and return to a normal running animation if she happened to be on the ground and moving
	// during her projectile firing.
	if (_isAiming && !_useHeld){
		aimReturnTimer += DELTA_TIME;
		if (aimReturnTimer >= BEAM_LOWER_TIME){
			stateFlags &= ~(1 << AIMING_FRONT);
			aimReturnTimer = 0;
		}
	}
}

#endregion

#region Projectile/bomb spawning functions

/// @description Checks for the value currently stored in "curWeapon" to determine what projectile will be
/// fired by Samus's arm cannon. Each bit in the variable represent a different one; from her various beams to 
/// her missiles as well.
/// @param {Bool}	charged		Determines if the beam/missile was properly charged up before firing.
create_projectile = function(_charged){
	var _splitBeam = event_get_flag(FLAG_BEAM_SPLITTER);
	switch(curWeapon){
		default: // By default the Power Beam will always be fired.
		case (1 << POWER_BEAM):		// = 1
			if (_splitBeam)	{create_power_beam_split(x, y, image_xscale, _charged);}
			else			{create_power_beam(x, y, image_xscale, _charged);}
			break;
		case (1 << ICE_BEAM):		// = 2
			break;
		case (1 << TESLA_BEAM):		// = 4
			break;
		case (1 << PLASMA_BEAM):	// = 8
			break;
		case (1 << MISSILE):		// = 16
			create_missile(x, y, image_xscale); // No charge flag necessary.
			break;
		case (1 << ICE_MISSILE):	// = 32
			break;
		case (1 << SHOCK_MISSILE):	// = 64
			break;
	}
}

/// POWER BEAM ///////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Creates the projectile for Samus's standard power beam, which is just a single, fast-moving
/// projectile that can be fired in four unique directions: up, down, left, and right.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	imageXScale		Samus current facing direction along the horizontal axis.
/// @param {Real}	charged			Determines if the power beam will be its more powerful "charged" counterpart.
create_power_beam = function(_x, _y, _imageXScale, _charged){
	var _projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile) {initialize(state_default, _x, _y, _imageXScale, _charged);}
}

/// @description Creates the projectile for the power beam influenced by the Beam Splitter powerup. Instead
/// of a single projectile, the power beam will now create three beams that will quickly split away from each
/// other before all moving parallel to each other; similar to how the Spazer Beam looked in Metroid II.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	imageXScale		Samus current facing direction along the horizontal axis.
/// @param {Real}	charged			Determines if the power beam projectiles were "charged" before being fired.
create_power_beam_split = function(_x, _y, _imageXScale, _charged){
	// Two lines below are unchanged from the standard power beam's creation function; making this instance
	// the middle of the three that are created for the beam splitter's variation.
	var _projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile) {initialize(state_default, _x, _y, _imageXScale, _charged);}
	
	// Creating the "upper" power beam, which is another way to describe that it will be the one moving in the
	// negative direction of whatever axis is perpendicular to its moving axis.
	_projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile){
		stateFlags |= (1 << UPPER_POWER_BEAM); // Must be done before initialization.
		initialize(state_beam_splitter, _x, _y, _imageXScale, _charged);
	}
	
	// Creating the "lower" power beam, which moves toward the positive direction of whatever axis is perpendicular
	// to the one it is moving toward by default. (The "lower" of the three when facing right or left).
	_projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile){
		stateFlags |= (1 << LOWER_POWER_BEAM); // Must be done before initialization.
		initialize(state_beam_splitter, _x, _y, _imageXScale, _charged);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// MISSILES (STANDARD, ICE, SHOCK) //////////////////////////////////////////////////////////////////////////////

/// @description Creates the standard missile projectile, which deals heavy damage and can destroy missile
/// blocks. Once upgraded to the "Super Missile" it will move faster, deal even more damage, and also shake
/// the screen when it collides with anything.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	imageXScale		Samus current facing direction along the horizontal axis.
create_missile = function(_x, _y, _imageXScale){
	if (numMissiles > 0){ // Can't use a missile without ammunition.
		var _vspd = vspd;
		var _projectile = instance_create_object(0, 0, obj_missile);
		with(_projectile){
			initialize(state_default, _x, _y, _imageXScale, false);
			// Preserve the player's velocity for whatever direction the missile is heading toward to prevent
			// the missile from moving too slow relative to the player's movement.
			if (IS_MOVING_HORIZONTAL){
				hspd = other.hspd;
			} else if (_vspd >= 0 && IS_MOVING_DOWN){
				vspd = other.vspd;
				vAccel *= 2; // Doubles acceleration to prevent Samus falling faster than the missile accelerates.
			}
		}
		numMissiles--; // Subtracts one missile from the current ammo reserve.
	}
}

/// @description 
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	imageXScale		Samus current facing direction along the horizontal axis.
create_ice_missile = function(_x, _y, _imageXScale){
	if (numMissiles > 3){ // Can't use an ice missile without at least three remaining.
		//var _vspd = vspd;
		//var _projectile = instance_create_object(0, 0, obj_ice_missile);
		//numMissiles -= 3; // Subtracts three missiles from the current ammo reserve.
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
__initialize = initialize;
/// @description Initializes the player object; setting their first state, placing them at the correct coordinates
/// in the starting room, setting their initial sprite, and flipping the required bit flags to allow the sprite
/// to render AND to allow the object to move along sloped floors.
/// @param {Function}	state
initialize = function(_state){
	__initialize(_state);
	entity_set_position(128, 336);
	entity_set_sprite(introSprite, spr_empty_mask);
	stateFlags = (1 << USE_SLOPES) | (1 << DRAW_SPRITE);
}

#endregion

#region Additional collision functions

/// @description Processing collision with a collider that interacts with Samus uniquely. It will be destroyed
/// by Samus is she walks across it, but won't be destroyed or manipulated otherwise. This means any other
/// entity can walk along this floor and have it react like a standard collider would.
fallthrough_floor_collision = function(){
	with(instance_place(x, y + 1, obj_destructible_weight)){
		if (!IS_DESTROYED){
			destructible_destroy_self();
			other.vspd = 0;
		}
	}
}

/// @description Checks for collision between the player and a collectible. It does so by temporarily enabling
/// the collider for the item (If one exists) and checking those collision bounds with the player's. If they
/// are intersecting, the collectible will be given to the player.
player_collectible_collision = function(){
	with(instance_nearest(x, y, par_collectible)){
		mask_index = -1; // Temporarily enable the collectible's collision box to check again the player's.
		if (!IS_HIDDEN && place_meeting(x, y, obj_player)){
			// TODO -- Add additional code that opens a menu to display the upgrade's information //
			collectible_collect_self();
		}
		mask_index = spr_empty_mask;
	}
}

/// @description
player_liquid_collision = function(){
	// 
	if (IS_SUBMERGED){
		// 
		var _id = noone;
		with(liquidData){
			_id = liquidID;
			if (damage == 0) {break;}
			damageTimer += DELTA_TIME;
			if (damageTimer >= damageInterval){
				damageTimer -= damageInterval;
				//show_debug_message("Damage dealt.");
			}
		}
		
		// 
		if (_id == noone || !place_meeting(x, y, _id)){
			// 
			if (!event_get_flag(FLAG_GRAVITY_SUIT)){
				maxHspdFactor +=	liquidData.maxHspdPenalty;
				maxVspdFactor +=	liquidData.maxVspdPenalty;
				hAccelFactor +=		liquidData.hAccelPenalty;
				vAccelFactor +=		liquidData.vAccelPenalty;
			}
			
			// 
			with(liquidData){
				liquidID =			noone;
				maxHspdPenalty =	0;
				maxVspdPenalty =	0;
				hAccelPenalty =		0;
				vAccelPenalty =		0;
				damage =			0;
				damageInterval =	0;
				damageTimer	=		0;
			}
			stateFlags &= ~(1 << SUBMERGED);
		}
		return;
	}
	
	// 
	var _id = instance_place(x, y, par_liquid);
	if (_id != noone){
		with(liquidData){
			liquidID =			_id;
			maxHspdPenalty =	_id.maxHspdPenalty;
			maxVspdPenalty =	_id.maxVspdPenalty;
			hAccelPenalty =		_id.hAccelPenalty;
			vAccelPenalty =		_id.vAccelPenalty;
			damage =			_id.damage;
			damageInterval =	_id.damageInterval;
		}
		
		// 
		if (!event_get_flag(FLAG_GRAVITY_SUIT)){
			maxHspdFactor -=	liquidData.maxHspdPenalty;
			maxVspdFactor -=	liquidData.maxVspdPenalty;
			hAccelFactor -=		liquidData.hAccelPenalty;
			vAccelFactor -=		liquidData.vAccelPenalty;
		}
		
		// 
		stateFlags |= (1 << SUBMERGED);
		vspdRecoil = 0;
		hspd *= 0.35;
		vspd *= 0.15;
	}
}

#endregion

#region State function initializations

/// @description Samus's introduction state. From here, all the player will be able to do is press either the 
/// right or left inputs on their in-use input device in order to activate Samus; sending them to her default
/// state after the previous condition is met.
state_intro = function(){
	process_input();
	var _input = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_input != 0){
		object_set_next_state(state_default);
		entity_set_sprite(standSpriteFw, standingMask);
		image_xscale = _input;
	}
}

/// @description 
state_default = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Handling "gravity" which is just to see if Samus is no longer on the floor or not. If she isn't on the
	// floor, her state will be switched to her airborune state; where gravity Samus's current vertical
	// velocity are properly utilized.
	apply_gravity(MAX_FALL_SPEED);
	if (!IS_GROUNDED){
		object_set_next_state(state_airbourne);
		entity_set_sprite(jumpSpriteFw, jumpingMask);
		stateFlags &= ~(1 << MOVING);
		jumpStartTimer = 0;
		aimReturnTimer = 0;
		return; // State changed; ignore input and immediately switch over to "airbourne" state.
	}
	
	// Another method of activating Samus's airborune state, but this is done by pressing the input set for
	// jumping. After that, Samus will have her vertical velocity set to whatever her jump height is (Stored
	// as her "maxVspd") and she will either enter a standard jump (Horizontal speed lower than 1) or a
	// somersault jump (Moving fast enough and not firing from Samus's arm cannon).
	if (IS_JUMP_PRESSED){
		object_set_next_state(state_airbourne);
		if (abs(hspd) >= 1 && !IS_AIMING){
			if (event_get_flag(FLAG_SCREW_ATTACK)) {stateFlags |= (1 << JUMP_ATTACK);}
			stateFlags |= (1 << JUMP_SPIN);
			jumpStartTimer = 0;
		}
		stateFlags &= ~((1 << GROUNDED) | (1 << MOVING));
		vspd = get_max_vspd();
		return; // State changed; don't process movement/animation within this function.
	}
	
	// Handling horizontal movement for both directions.
	var _movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_movement != 0){
		// Instantaneous velocity reset whenever the player changes movement directions before a complete
		// deceleration can occur (If movement inputs were even released prior to the direction switch).
		if ((_movement == -1 && hspd > 0) || (_movement == 1 && hspd < 0)){
			hspdFraction = 0;
			hspd = 0;
		}
		
		// Slowly increase Samus's horizontal velocity by her acceleration until it reaches her maximum
		// possible horizontal movement speed. After that, she'll constantly be at that maximum speed.
		var _maxHspd = get_max_hspd();
		hspd += _movement * get_hor_accel() * DELTA_TIME;
		if (hspd < -_maxHspd)		{hspd = -_maxHspd;}
		else if (hspd > _maxHspd)	{hspd = _maxHspd;}
		
		// Let the object know that it is "moving" (This is used for assigning the walking animation at the
		// end of this state) and also ensure Samus is facing the proper direction that the player is moving
		// her in.
		stateFlags |= (1 << MOVING);
		image_xscale = _movement;
	} else if (hspd != 0 || IS_MOVING){
		// Smoothly decelerate Samus until she becomes stationary again; this deceleration rate is the same
		// value used for her acceleration whenever the left or right inputs being pressed by the user.
		var _deltaAccel = get_hor_accel() * DELTA_TIME;
		hspd -= _deltaAccel * sign(hspd);
		if (hspd >= -_deltaAccel && hspd <= _deltaAccel){
			stateFlags &= ~((1 << MOVING) | (1 << AIMING_FRONT));
			hspdFraction = 0;
			hspd = 0;
		}
	}
	
	// A collision check that occurs outside of the standard function in order to flip Samus's "moving" flag
	// to 0 if the player is moving her in the direction of a wall. Otherwise, her walking animation will play
	// in a glitchy manner despite the fact she isn't moving at all.
	if (place_meeting(x + _movement, y, par_collider)){
		var _yOffset = 0;
		while(place_meeting(x + _movement, y - _yOffset, par_collider) && _yOffset < maxHspd) {_yOffset++;}
		if (place_meeting(x + _movement, y - _yOffset, par_collider)) {stateFlags &= ~(1 << MOVING);}
	}
	
	// Entering Samus's crouching state, which lowers her down; shrinking her hitbox a bit vertically and 
	// moving her beam low enough to hit smaller targets. It's accessed by simply pressing the down input.
	if (IS_DOWN_PRESSED){
		object_set_next_state(state_crouching);
		entity_set_sprite(crouchSprite, crouchingMask);
		stateFlags &= ~((1 << AIMING_UP) | (1 << MOVING));
		stateFlags |= (1 << CROUCHING);
		aimReturnTimer = 0;
		hspdFraction = 0;
		hspd = 0;
		return; // State changed; don't bother continuing with this state function.
	}
	
	// The aiming logic for Samus's default state, which only allows her to aim upward and forward; the latter
	// being the default aiming direction for her when aiming inputs (Up/down, respectively) aren't pressed.
	if (IS_UP_PRESSED){
		stateFlags &= ~(1 << AIMING_FRONT);
		stateFlags |= (1 << AIMING_UP);
	} else if (IS_UP_RELEASED){
		stateFlags &= ~(1 << AIMING_UP);
	}
	
	// Another way of aiming Samus up that can only happen when she very recently exited her crouching state.
	// In short, it checks if the player is holding down the up input, which handles both exiting crouch AND
	// aiming up in order to prevent Samus instantly snapping to her upward aiming substate. This creates a 
	// very short buffer for her to aim forward before snapping upward (As long as the up key is held for the
	// required duration of this "aim switch buffer").
	if ((stateFlags & (1 << AIMING_UP) == 0) && IS_UP_HELD){
		aimSwitchTimer += DELTA_TIME;
		if (aimSwitchTimer >= AIM_SWITCH_TIME){
			stateFlags &= ~(1 << AIMING_FRONT);
			stateFlags |= (1 << AIMING_UP);
			aimSwitchTimer = 0;
		}
	} else{
		aimSwitchTimer = 0;
	}
	
	// 
	update_arm_cannon(_movement);
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	
	// Setting a walking sprite to use if Samus is moving (Determined by the value of the bit flag "IS_WALKING"
	// at the end of the frame). She can have three possible animations for this substate: walking normally, 
	// with her beam aiming forward, or with her beam aiming upward.
	var _sState = stateFlags & ((1 << AIMING_FRONT) | (1 << AIMING_UP));
	if (IS_MOVING){
		var _animSpeed = abs(hspd) / maxHspd;
		switch(_sState){
			default:					entity_set_sprite(walkSpriteFw,	standingMask, _animSpeed);	break;
			case (1 << AIMING_FRONT):	entity_set_sprite(walkSpriteFwExt, standingMask, _animSpeed);	break;
			case (1 << AIMING_UP):		entity_set_sprite(walkSpriteUp,	standingMask, _animSpeed);	break;
		}
		return;
	}
	
	// The default sprites to use for this state, which are the standing sprites for Samus. There are two
	// possible sprites that can be set for this action: standing normally (same as aiming forward), or aiming
	// her beam upward.
	switch(_sState){
		default:					entity_set_sprite(standSpriteFw,	standingMask);	break;
		case (1 << AIMING_UP):		entity_set_sprite(standSpriteUp,	standingMask);	break;
	}
}

/// @description The state Samus is assigned to whenever she finds herself no longer on the ground (Meaning
/// there is no longer a "collider" beneath her current collision mask). From here, she'll be able to aim 
/// directly downward, which is only possible in this state. On top of that, she'll be allowed to jump multiple
/// timers if the proper item has been acquired. Other than those differences, it will act nearly identical
/// to the default and morphball states, respectively.
state_airbourne = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Calculating the gravity being applied to Samus for the frame. A check is performed below to see if she
	// has touched the floor. If she did, she will return from her airborune state to her default state, and
	// her horizontal velocity is reset as well as any jumping-specific substate flags.
	apply_gravity(MAX_FALL_SPEED);
	if (IS_GROUNDED){
		object_set_next_state(state_default);
		stateFlags &= ~((1 << JUMP_SPIN) | (1 << JUMP_ATTACK) | (1 << AIMING_DOWN));
		hspdFraction = 0;
		hspd = 0;
		
		// Offset Samus by the difference between the bottom of her collision mask while airbourne and her
		// collision mask for standing on the ground; ensuring she will be colliding perfectly with the floor
		// beneath her.
		var _bboxBottom = bbox_bottom;
		mask_index = standingMask;
		y -= (bbox_bottom - _bboxBottom);
		return; // State has changed; exit the function prematurely.
	}
	
	// When the jump input is activated, three possibilities can occur whilst airborune. The first is a check
	// for the double jump ability, which enables Samus to jump once more in the air regardless of if she's
	// somersaulting or not. The second will activate that somersaulting jump if she's moving horizontally 
	// and not aiming. Finally, a check for the space jump ability will occur if she's already in that 
	// somersaulting jump; allowing her to jump again indefinitely while in that same jump.
	if (IS_JUMP_PRESSED){
		if (!IS_AIMING){ // Samus cannot be aiming in any direction to enable somersaulting in the air and her space jump.
			if (!IS_JUMP_SPIN){ // Entering a somersault jump when airbourne.
				stateFlags &= ~((1 << AIMING_FRONT) | (1 << AIMING_DOWN) | (1 << AIMING_UP));
				if (event_get_flag(FLAG_SCREW_ATTACK)) {stateFlags |= (1 << JUMP_ATTACK);}
				stateFlags |= (1 << JUMP_SPIN);
				hspd = get_max_hspd() * image_xscale;
				jumpStartTimer = 0;
				aimReturnTimer = 0;
			} else if (vspd >= 2 && event_get_flag(FLAG_SPACE_JUMP)){ // Utilizing Samus's Space Jump ability (Overwrites the double jump).
			 vspd = get_max_vspd();
			}
		}
	}
	if (IS_JUMP_RELEASED && vspd < 0) {vspd *= 0.5;}
	
	// Handling horizontal movement, which is slightly different to how it is normally handled. The biggest
	// change is that Samus doesn't decelerate while airbourne, meaning her velocity will remain even if the
	// player isn't holding down any horizontal movement inputs until she lands.
	var _movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_movement != 0){
		// Moving Samus while airborune works nearly identically to how she moves while standing or in her
		// morphball form. The main differences are her acceleration is halved and there is no instanteous
		// velocity change when the movement direction is switched before her horizontal velocity reaches 0.
		var _maxHspd = get_max_hspd();
		hspd += _movement * get_hor_accel() * 0.5 * DELTA_TIME;
		if (hspd < -_maxHspd)		{hspd = -_maxHspd;}
		else if (hspd > _maxHspd)	{hspd = _maxHspd;}
		image_xscale = _movement;
		
		// This chunk of code exists to allow the player to exit the downward aiming substate by moving in
		// either horizontal direction for a small predetermined amount of time. If they release the movement
		// keys before this amount of time has elapsed, Samus will remain in her downward aiming substate.
		if (stateFlags & (1 << AIMING_DOWN) != 0 && !IS_DOWN_HELD){
			aimReturnTimer += DELTA_TIME;
			if (aimReturnTimer >= AIM_SWITCH_TIME){
				stateFlags &= ~(1 << AIMING_DOWN);
				aimReturnTimer = 0;
			}
		}
	} else{ // Resetting the aim return timer for exiting downward aiming through horizontal movement inputs.
		aimReturnTimer = 0;
	}
	
	// Determining Samus's aiming direction as well as if she can enter morphball mode or not. For aiming, it
	// works a bit different to how her default state handles things; using button presses/releases instead of
	// a simple holding of the respective aiming input to remain aiming in that direction. For upward aiming,
	// it will seem identical to how it works in the default state despite this change, but the change allows
	// for a single press of the down key to activate her downward aiming substate. From there, the player can
	// press down again to enter morphball mode in the air, or they can press the up key to return to aiming
	// forward.
	var _vInput = IS_DOWN_PRESSED - IS_UP_PRESSED;
	if (_vInput == -1){
		if ((stateFlags & (1 << AIMING_DOWN) == 0)){ // Aiming upward until the player releases their up input.
			stateFlags &= ~((1 << AIMING_FRONT) | (1 << JUMP_SPIN) | (1 << JUMP_ATTACK));
			stateFlags |= (1 << AIMING_UP);
		} else{ // Exiting from aiming downward.
			stateFlags &= ~(1 << AIMING_DOWN);
		}
	} else if (_vInput == 1){
		if (stateFlags & (1 << AIMING_DOWN) == 0){ // Entering a downward aiming state.
			stateFlags &= ~((1 << AIMING_FRONT) | (1 << AIMING_UP) | (1 << JUMP_SPIN) | (1 << JUMP_ATTACK));
			stateFlags |= (1 << AIMING_DOWN);
		} else if (event_get_flag(FLAG_MORPHBALL)){ // Entering morphball mode while in the air.
			object_set_next_state(state_enter_morphball);
			var _bboxBottom = bbox_bottom;
			entity_set_sprite(ballEnterSprite, morphballMask);
			y -= bbox_bottom - _bboxBottom;
			return;
		}
	} else if (IS_UP_RELEASED){ // Stopping Samus from aiming upward.
		stateFlags &= ~(1 << AIMING_UP);
	}
	
	// 
	update_arm_cannon(_movement);
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_liquid_collision();
	
	// Assign Samus's jumping animation, which is determined by her aiming substates, and also her "jumpspin"
	// substate; the latter being applied based on if she was moving before the jump was entered OR if the
	// jump button is pressed while airbourne and not somersaulting. Aside from that, the sprite will be
	// assigned based on what her aiming direction is: upward, downward (Unique to jumping), or forward.
	var _sState = stateFlags & ((1 << AIMING_FRONT) | (1 << AIMING_UP) | (1 << AIMING_DOWN) | (1 << JUMP_SPIN));
	switch(_sState){
		default:					entity_set_sprite(jumpSpriteFw,		jumpingMask);	break;
		case (1 << AIMING_UP):		entity_set_sprite(jumpSpriteUp,		jumpingMask);	break;
		case (1 << AIMING_DOWN):	entity_set_sprite(jumpSpriteDown,	jumpingMask);	break;
		// Jumpspin animation won't play until the "jumpStartTimer" variable hits 0; using the default jump sprite until then.
		case (1 << JUMP_SPIN):		if (jumpStartTimer == JUMPSPIN_ANIM_TIME) {entity_set_sprite(jumpSpriteSpin, jumpingMask, maxHspdFactor, 0, 1);}
									else									  {entity_set_sprite(jumpSpriteFw, jumpingMask);}	break;
	}
	
	// Counting down the time that pauses the somersaulting animation in order to have a lead-in "animation" 
	// that simply uses the default forward-facing jumping sprite during that duration.
	if (jumpStartTimer != JUMPSPIN_ANIM_TIME){
		jumpStartTimer += DELTA_TIME;
		if (jumpStartTimer >= JUMPSPIN_ANIM_TIME) {jumpStartTimer = JUMPSPIN_ANIM_TIME;}
	}
}

/// @description The state that is executed whenever Samus is crouching. During said state she will be unable
/// to move horizontally or jump. Hitting the left or right movement inputs will simply face Samus in the
/// direction of the last of those inputs that was pressed.
state_crouching = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// By pressing the up OR the jump input, Samus will exit her crouching state.
	if (IS_UP_PRESSED || IS_JUMP_PRESSED){
		crouch_to_standing();
		return; // State was changed; don't process any more code in this function.
	}
	
	// Entering Samus's morphball mode, which involves her passing through a "passing" state that will then
	// determine if she'll enter or exit morphball (She'll always enter morphball when set to that state by
	// this bit of code).
	if (IS_DOWN_PRESSED && event_get_flag(FLAG_MORPHBALL)){
		object_set_next_state(state_enter_morphball);
		entity_set_sprite(ballEnterSprite, morphballMask);
		return; // State was changed; don't process any more code in this function.
	}
	
	// Hitting the right or left movement keys, which will simply change Samus's facing direction when pressed.
	// When either input is held down for a specific amount of time, Samus will exit her crouching state.
	var _movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_movement != 0){
		standingTimer += DELTA_TIME;
		if (standingTimer >= STAND_UP_TIME){
			crouch_to_standing();
			standingTimer = 0;
		}
		image_xscale = _movement;
	} else{ // Reset timer for making Samus stand through left or right input when they are released early.
		standingTimer = 0;
	}
	
	// 
	update_arm_cannon(_movement);
}

/// @description A passing state that will play Samus's one-frame animation for entering her morphball form.
/// The time for this transition being determined by the value of the "MORPHBALL_ANIM_TIME" constant. After
/// that amount of time has elapsed, she'll either enter or exit morphball depending on what state she was in
/// previously.
state_enter_morphball = function(){
	mBallEnterTimer += DELTA_TIME;
	if (mBallEnterTimer >= MORPHBALL_ANIM_TIME){
		mBallEnterTimer = 0;
		
		// ENTERING MORPHBALL -- Occurs when Samus was previously in her crouching or airbourne states, 
		// respectively. She will be set to her default morphball state, and her substate flags will be 
		// updated to reflect her new state swap.
		if (stateFlags & (1 << MORPHBALL) == 0){
			object_set_next_state(state_morphball);
			entity_set_sprite(morphballSprite, morphballMask);
			stateFlags &= ~((1 << AIMING_DOWN) | (1 << CROUCHING));
			stateFlags |= (1 << MORPHBALL);
			return;
		}
		
		// EXITING MORPHBALL -- Occurs when Samus was in her default morphball state before entering this one.
		// She will be set to either her airbourne state if she was in the air when she exited her morphball
		// mode, or her crouching state if she was on the ground.
		stateFlags &= ~(1 << MORPHBALL);
		if (!IS_GROUNDED){
			object_set_next_state(state_airbourne);
			var _bboxBottom = bbox_bottom;
			entity_set_sprite(jumpSpriteFw, jumpingMask);
			y -= bbox_bottom - _bboxBottom;
			return;
		}
		object_set_next_state(state_crouching);
		entity_set_sprite(crouchSprite, crouchingMask);
		stateFlags |= (1 << CROUCHING);
		standingTimer = 0;
		hspdFraction = 0;
		hspd = 0;
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
}

/// @description 
state_morphball = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Applying gravity and also the recoil that can occur when the morphball hits the ground especially hard.
	// If the vertical velocity is low enough, no bounce will occur, but until then a bounce will make the
	// morphball airborune again until that velocity threshold is passed.
	if (vspd >= 4.5 && !IS_SUBMERGED) {vspdRecoil = vspd * 0.5;}
	apply_gravity(MAX_FALL_SPEED);
	if (IS_GROUNDED){
		if (vspdRecoil > 0){ // Causes the morphball recoil bounce.
			stateFlags &= ~(1 << GROUNDED);
			vspd = -vspdRecoil;
			vspdRecoil = 0;
		} else if (hspd != 0 && vspd == 0){ // Allows deceleration after the morphball bomb causes horizontal recoil (So long as no movement inputs are pressed in that time).
			stateFlags |= (1 << MOVING);
		}
	}
	
	// Handling the morphball's jumping capabilities, which are unlocked after Samus collects the "Spring Ball"
	// upgrade. Once acquired, Samus can press the jump input while grounded to jump into the air as she would
	// while in her suit form.
	if (IS_JUMP_PRESSED && IS_GROUNDED && vspdRecoil == 0 && event_get_flag(FLAG_SPRING_BALL)){
		stateFlags &= ~(1 << GROUNDED);
		vspd = BASE_JUMP_HEIGHT * maxVspdFactor;
	}
	if (IS_JUMP_RELEASED && vspd < 0) {vspd /= 2;}
	
	// Handling horizontal movement while in morphball mode, which functions very similar to how said movement
	// works in Samus's default suit form. Holding left or right (But not both at once) will result in her
	// moving in the desired direction; releasing said key will slow her down until she is no longer moving.
	var _movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_movement != 0){
		// Instantaneous velocity reset whenever the player changes movement directions before a complete
		// deceleration can occur (If movement inputs were even released prior to the direction switch).
		if ((_movement == -1 && hspd > 0) || (_movement == 1 && hspd < 0)){
			hspdFraction = 0;
			hspd = 0;
		}
		
		// Accelerate Samus at a rate of 60% her standard acceleration when she's in morphball move. Other
		// than that, the code is identical to her horizontal movement physics when moving along the ground
		// in her non-morphball state.
		var _maxHspd = get_max_hspd();
		hspd += _movement * get_hor_accel() * 0.6 * DELTA_TIME;
		if (hspd < -_maxHspd)		{hspd = -_maxHspd;}
		else if (hspd > _maxHspd)	{hspd = _maxHspd;}
		
		// Finally, flip the morphball so that it faces the direction the user in moving Samus in, and set the
		// state flag for moving to true to signify movement is now occuring.
		stateFlags |= (1 << MOVING);
		image_xscale = _movement;
	} else if (hspd != 0 && IS_MOVING){
		var _deltaAccel = get_hor_accel() * 0.6 * DELTA_TIME * sign(hspd);
		hspd -= _deltaAccel; // Like accelerating, Samus will decelerate at 60% her normal speed.
		if (hspd >= -_deltaAccel && hspd <= _deltaAccel){
			stateFlags &= ~(1 << MOVING);
			hspd = 0;
		}
	}
	
	// Exiting out of morphball mode, which will call the function that checks for a collision directly above
	// Samus's head. If there's a collision, she'll be unable to transform back into her standard form.
	if (IS_UP_PRESSED){
		morphball_to_crouch();
		return; // State potentially changed; exit the current state function prematurely.
	}
	
	// Spawning in a standard morphball bomb, which is only possible if there are less than the maximum bombs
	// currently deployed in the current room, the buffer timer is a value of zero, and the player presses the
	// proper input for creating one.
	if (IS_USE_PRESSED && bombDropTimer == 0 && event_get_flag(FLAG_BOMBS) && instance_number(obj_player_bomb) < MAX_STANDARD_BOMBS){
		var _id = instance_create_object(x, y - 5, obj_player_bomb, depth - 1);
		with(_id) {initialize(state_default);}
		bombDropTimer = BOMB_DROP_RATE;
	}
	
	// Counting down the timer that prevents spamming morphball bombs with each push of the "use weapon" input.
	// Once this timer hits zero again, another bomb can be deployed should the player choose to do so.
	if (bombDropTimer > 0){
		bombDropTimer -= DELTA_TIME;
		if (bombDropTimer <= 0) {bombDropTimer = 0;}
	}
	
	// Handling the bomb expolosion's physics. It will move Samus to either the left or the right depending on
	// where she is positioned relative to the center of the bomb's explosion. On top of that, the morphball
	// will shot up based on the bomb's set jump height.
	var _id = instance_place(x, y, obj_player_bomb_explode);
	if (bombExplodeID != _id && _id != noone && y <= _id.y + 10){
		stateFlags &= ~(1 << MOVING); // Allows preservation of velocity from bomb jump.
		bombExplodeID = _id;
		vspd = bombJumpVspd;
		hspd = ((x - _id.x) / 12) * maxHspd;
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	
	// Assign the morphball's sprite, and update its image speed based on whatever its current horizontal
	// movement factor is set to (Ex. A factor of 0.5 would make the morphball animate at half its normal
	// speed, and so on).
	entity_set_sprite(morphballSprite, morphballMask, maxHspdFactor);
}

#endregion

// SET A UNIQUE COLOR FOR SAMUS'S BOUNDING BOX (FOR DEBUGGING ONLY)
collisionMaskColor = HEX_LIGHT_BLUE;