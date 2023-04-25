#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Create a light source that will be user to illuminate Samus's visor and also flash rapidly during her
// screw attack animation.
object_add_light_component(x, y, 0, LIGHT_OFFSET_Y_GENERAL, LIGHT_DEFAULT_RADIUS, HEX_LIGHT_GREEN, LIGHT_DEFAULT_STRENGTH, true);

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

// Stores Samus's horizontal movement direction for a given frame (1 = moving right, -1 = left).
movement = 0;

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

// Variables that keep track of the various resources Samus can deplete throughout regular gameplay. The max
// possible amount that can be stored of each can be upgrade through finding the relevant expansion tanks in
// the game world.
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
standingTimer = 0.0;
aimReturnTimer = 0.0;
aimSwitchTimer = 0.0;
mBallEnterTimer = 0.0;
jumpStartTimer = 0.0;

// Keeps track of how high the morphball will bounce relative to its falling speed when it initially hits the
// ground. A high enough value will make the morphball bounce into the air again.
vspdRecoil = 0.0;

// Variables for Samus's strandard bombs; determining how fast she can deploy them, how many she can deploy at
// any given time, the power of the blast that allows for bomb jumping, and a variable to track the explosion
// that hit her so it doesn't constantly collide with it every frame; skewing the true vertical velocity if
// this was the case.
bombDropTimer = 0.0;
bombJumpVspd = -4.0;
bombExplodeID = noone;

// The arm cannon is a separate object that is rendered on top of Samus's current sprite whenever it is needed.
// So, its instance is created here and stored in a variable for easy reference and manipulation. The bottom
// two variables store the offset position for the arm cannon at the time Samus got hit stunned since those
// offsets do not change for the duration of the stunned state.
armCannon = instance_create_struct(obj_arm_cannon);
armCannonX = 0;
armCannonY = 0;

// 
curBeam = (1 << POWER_BEAM);
curMissile = (1 << MISSILE);
curWeapon = curBeam;

// 
tapFireRate = 1;
holdFireRate = 1;
fireRateTimer = 0.0;
chargeTimer = 0.0;

// 
liquidData = {
	// 
	liquidID : noone,
	
	// 
	maxHspdPenalty : 0.0,
	maxVspdPenalty : 0.0,
	hAccelPenalty : 0.0,
	vAccelPenalty : 0.0,
	
	// 
	damage : 0,
	damageInterval : 0.0,
	damageTimer : 0.0,
};

// 
jumpEffectID = ds_list_create();
effectTimer = JUMP_EFFECT_INTERVAL;

// 
warpID = noone;

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
			(keyboard_check(KEYCODE_USE_WEAPON)		<<	USE_WEAPON) |
			(keyboard_check(KEYCODE_SWAP_WEAPON)	<<	SWAP_WEAPON) |
			(keyboard_check(KEYCODE_HOTKEY_ONE)		<<	SWAP_POWER_BEAM) |
			(keyboard_check(KEYCODE_HOTKEY_TWO)		<<	SWAP_ICE_BEAM) |
			(keyboard_check(KEYCODE_HOTKEY_THREE)	<<	SWAP_WAVE_BEAM) |
			(keyboard_check(KEYCODE_HOTKEY_FOUR)	<<	SWAP_PLASMA_BEAM) |
			(keyboard_check(KEYCODE_HOTKEY_FIVE)	<<	SWAP_MISSILES) |
			(keyboard_check(KEYCODE_HOTKEY_SIX)		<<	SWAP_ICE_MISSILES) |
			(keyboard_check(KEYCODE_HOTKEY_SEVEN)	<<	SWAP_SHOCK_MISSILES) |
			(keyboard_check(KEYCODE_ALT_WEAPON)		<<	ALT_WEAPON);
	}
}

/// @description Increments or decrements Samus's current "hspd" (Her current horizontal velocity) based on the
/// movement direction determined by the player's inputs for the given frame (Only right = positive velocity,
/// only left = negative velocity, both inputs = no velocity). Also checks if Samus is currently against a
/// wall, which will instantly set her hspd to 0 and her "moving" flag to false.
/// @param {Real}	hspdFactor		Maximum possible hspd (Relative to Samus's current maximum) for just this function.
/// @param {Real}	hAccelFactor	Determines horizontal acceleration rate for Samus during this iteration of the function.
/// @param {Bool}	snapToZero		If true, Samus's horizontal velocity will be set to zero upon changing directions.
/// @param {Bool}	canDecelerate	It true, Samus will be able to slow down after no horizontal movement inputs are pressed.
process_horizontal_movement = function(_hspdFactor, _hAccelFactor, _snapToZero, _canDecelerate){
	// Logic for updating player's current horizontal velocity relative to the movement input pressed.
	movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (movement != 0){ // Player is moving; apply acceleration in required direction.
		// Optionally snapping Samus's current velocity to zero if she changes directions without coming to
		// a complete stop beforehand.
		if (_snapToZero && ((movement == -1 && hspd > 0.0) || (movement == 1 && hspd < 0.0))){
			hspdFraction = 0.0;
			hspd = 0.0;
		}
		
		// Increase (Moving to the right) or decrease (Moving to the left) Samus's current horizontal velocity
		// value; relative to her current horizontal acceleration speed. Samus's image is flipped to match her
		// movement direction.
		hspd += movement * get_hor_accel() * _hAccelFactor * DELTA_TIME;
		image_xscale = movement;
		
		// Capping the maximum possible horizontal speed of Samus to whatever her current maximum is relative
		// to her movement direction.
		var _maxHspd = get_max_hspd() * _hspdFactor;
		if (hspd > _maxHspd)		{hspd = _maxHspd;}
		else if (hspd < -_maxHspd)	{hspd = -_maxHspd;}
		
		// Set Samus's flag for "moving" to let the rest of her code know she is currently moving.
		stateFlags |= (1 << MOVING);
	} else if (_canDecelerate){ // Player is no longer being moved; decelerate her horizontal velocity to zero.
		var _deltaAccel = get_hor_accel() * _hAccelFactor * DELTA_TIME;
		hspd -= _deltaAccel * sign(hspd);
		if (hspd >= -_deltaAccel && hspd <= _deltaAccel){ // Set all hspd values to zero and disable any necessary flags.
			stateFlags &= ~((1 << MOVING) | (1 << AIMING_FRONT));
			hspdFraction = 0.0;
			hspd = 0.0;
		}
	}
	
	// Applying a fix for Samus's horizontal velocity that can occur with this movement and collision system.
	// In short, it will check to see that there isn't an obstacle right in front of Samus. If there is one,
	// her hspd values are zeroed out and her flag for "moving" is set to false. If this wasn't done her
	// hspd value would constantly increase to 1 before zeroing out at the collision check so long as the
	// player was holding either the right or left movement inputs; making her run while against walls due
	// to that "moving" flag never being set to false despite any actual movement being obstructed.
	if (IS_GROUNDED && IS_MOVING && place_meeting(x + movement, y, par_collider)){
		var _yOffset = 0;
		while(place_meeting(x + movement, y - _yOffset, par_collider) && _yOffset < maxHspd) {_yOffset++;}
		if (place_meeting(x + movement, y - _yOffset, par_collider)){
			stateFlags &= ~(1 << MOVING);
			hspdFraction = 0.0;
			hspd = 0.0;
		}
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
		standingTimer = 0.0;
		reset_light_source();
		return; // Exit before mask can be reset by the line below.
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
		vspdRecoil = 0.0;			// Reset variables related to the morphball to default values.
		bombDropTimer = 0.0;
		bombExplodeID = noone;
		return; // Exit before mask can be reset by the line below.
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
	// Create some local boolean values that are utilized throughout this function. Switch Samus to her
	// "aiming" substate, which will prevent her from somersaulting or walking without her beam drawn until
	// that return timer exceeds a certain value.
	var _isAiming = IS_AIMING;
	var _useHeld = IS_USE_HELD;
	var _usePressed = IS_USE_PRESSED;
	var _useReleased = IS_USE_RELEASED;
	if ((_useHeld || _usePressed) && !_isAiming){
		if (IS_JUMP_SPIN || IS_JUMP_ATTACK){
			stateFlags &= ~((1 << JUMP_SPIN) | (1 << JUMP_ATTACK));
			reset_light_source();
		}
		stateFlags |= (1 << AIMING_FRONT);
		aimReturnTimer = 0.0;
	}
	
	// Handling the charge beam logic, which is only factored in if the player doesn't have a missile equipped
	// and they have the optional charge beam item collected.
	var _isCharged = false;
	if (!IS_MISSILE_EQUIPPED){
		var _chargeBeam = event_get_flag(FLAG_CHARGE_BEAM);
		if (_useHeld && _chargeBeam){
			chargeTimer += DELTA_TIME;
			if (chargeTimer >= MAX_CHARGE_TIME) {chargeTimer = MAX_CHARGE_TIME;}
		
			// Prevent any normal beam projectile from being created while the charge timer is increasing.
			if (chargeTimer >= min(tapFireRate, 5.0)){
				aimReturnTimer = 0.0;
				return;
			}
		}
		
		// Determine if the beam is fully charged relative to the timer's current value and if the player has
		// released the fire button. The timer for charge is reset on this button's release.
		_isCharged = (_useReleased && _chargeBeam && chargeTimer >= MIN_CHARGE_TIME);
		if (_useReleased) {chargeTimer = 0.0;}
	}
	
	// 
	var _holdingFire = (_useHeld && !_isCharged && fireRateTimer == holdFireRate);
	var _tappingFire = (_usePressed && fireRateTimer >= tapFireRate);
	var _chargeFire = (_useReleased && _isCharged);
	if (_holdingFire || _tappingFire || _chargeFire){
		create_projectile(_isCharged);
		fireRateTimer = 0.0;
		aimReturnTimer = 0.0;
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
			aimReturnTimer = 0.0;
		}
	}
}

/// @description Resets Samus's ambient light source to match the settings it had when it was being used to
/// represent the light coming from her helmet's visor. It will assume Samus is standing, and will place the
/// light at the offset that matches such a state.
reset_light_source = function(){
	var _isAimingUp = IS_AIMING_UP;
	with(lightComponent){
		set_properties(LIGHT_DEFAULT_RADIUS, HEX_LIGHT_GREEN, LIGHT_DEFAULT_STRENGTH);
		isActive = !_isAimingUp;
	}
	lightOffsetX = LIGHT_OFFSET_X_GENERAL;
	lightOffsetY = LIGHT_OFFSET_Y_GENERAL;
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
			tapFireRate = 5;
			holdFireRate = 20;
			break;
		case (1 << ICE_BEAM):		// = 2
			if (_splitBeam)	{/*create_ice_beam_split(x, y, image_xscale, _charged);*/}
			else			{create_ice_beam(x, y, image_xscale, _charged);}
			tapFireRate = 36;
			holdFireRate = 46;
			break;
		case (1 << WAVE_BEAM):		// = 4
			show_debug_message("WAVE BEAM");
			tapFireRate = 18;
			holdFireRate = 28;
			break;
		case (1 << PLASMA_BEAM):	// = 8
			show_debug_message("PLASMA BEAM");
			tapFireRate = 14;
			holdFireRate = 26;
			break;
		case (1 << MISSILE):		// = 16
			create_missile(x, y, image_xscale); // No charge flag necessary.
			tapFireRate = 24;
			holdFireRate = 38;
			break;
		case (1 << ICE_MISSILE):	// = 32
			show_debug_message("ICE MISSILE");
			tapFireRate = 40;
			holdFireRate = 60;
			break;
		case (1 << SHOCK_MISSILE):	// = 64
			show_debug_message("SHOCK MISSILE");
			tapFireRate = 32;
			holdFireRate = 46;
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

/// ICE BEAM /////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description 
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	imageXScale		Samus current facing direction along the horizontal axis.
/// @param {Real}	charged			Determines if the power beam projectiles were "charged" before being fired.
create_ice_beam = function(_x, _y, _imageXScale, _charged){
	var _projectile = instance_create_object(0, 0, obj_ice_beam);
	with(_projectile) {initialize(state_default, _x, _y, _imageXScale, _charged);}
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
				vAccel *= 2.0; // Doubles acceleration to prevent Samus falling faster than the missile accelerates.
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
	if (numMissiles > 5){ // Can't use an ice missile without at least five remaining.
		//var _vspd = vspd;
		//var _projectile = instance_create_object(0, 0, obj_ice_missile);
		//numMissiles -= 5; // Subtracts three missiles from the current ammo reserve.
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endregion

#region Weapon swapping function

/// @description Swaps Samus's beam to another based on what beam hotkey was pressed by the user and what 
/// beams they currently have available to switch to. If the only beam available is the power beam, no switch
/// will occur. On top of that, if Samus is using her missiles, it will swap to one of her three available
/// missile types (If she has any variants unlocked).
check_swap_current_weapon = function(){
	if (IS_ALT_WEAPON_HELD && event_get_flag(FLAG_MISSILES)){
		// Swap to the next missile depending on which of the input(s) has been pressed by the player. The
		// priority of missiles is: standard, ice, and shock, whenever multiple of these inputs are pressed
		// at once occurs.
		if (IS_SWAP_MISS_PRESSED)		{curMissile = (1 << MISSILE);}
		else if (IS_SWAP_IMISS_PRESSED)	{curMissile = (1 << ICE_MISSILE);}
		else if (IS_SWAP_SMISS_PRESSED)	{curMissile = (1 << SHOCK_MISSILE);}
		
		// Update the variables for the fire rate timers and charging timers to reflect this change in weapon.
		if (curWeapon != curMissile){
			curWeapon = curMissile;
			tapFireRate = MISSILE_SWAP_TIME;
			holdFireRate = MISSILE_SWAP_TIME;
			fireRateTimer = 0.0;
			chargeTimer = 0.0;
		}
		return;
	}
	
	// Much like for missiles, the beam will be switched to whichever one has its hotkey pressed relative to
	// that beam hotkey's priority if multiple happen to be pressed at the same time by the player. The priority
	// order is as follows: power, ice, wave, and plasma, respectively.
	if (IS_SWAP_POWB_PRESSED)		{curBeam = (1 << POWER_BEAM);}
	else if (IS_SWAP_ICEB_PRESSED)	{curBeam = (1 << ICE_BEAM);}
	else if (IS_SWAP_WAVB_PRESSED)	{curBeam = (1 << WAVE_BEAM);}
	else if (IS_SWAP_PLAB_PRESSED)	{curBeam = (1 << PLASMA_BEAM);}
	
	// Update the variables for the fire rate timers and charging timers to reflect this change in weapon.
	if (curWeapon != curBeam){
		curWeapon = curBeam;
		tapFireRate = BEAM_SWAP_TIME;
		holdFireRate = BEAM_SWAP_TIME;
		fireRateTimer = 0.0;
		chargeTimer = 0.0;
	}
}

#endregion

#region Modified functions from parent object

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
__initialize = initialize;
/// @description Initializes the player object; setting their first state, placing them at the correct coordinates
/// in the starting room, setting their initial sprite, and flipping the required bit flags to allow the sprite
/// to render AND to allow the object to move along sloped floors.
/// @param {Function}	state
initialize = function(_state){
	__initialize(_state);
	entity_set_position(480, 320);
	entity_set_sprite(introSprite, spr_empty_mask);
	stateFlags = (1 << USE_SLOPES) | (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION) | (1 << INVINCIBLE);
	game_set_state(GSTATE_NORMAL, true);
}

/// @description A modification to the entity's hitpoint manipulation function; allowing the entity to be
/// given hitpoints or have them taken away depending on the modifier value. It will autiomatically handle
/// utilization of the reserve hitpoints should the player reach zero hitpoints while having some available
/// in their reserve. Otherwise, the player will be flagged as "destroyed" which will signal to the game
/// that the game over screen should be shown.
/// @param {Real}	modifier	The value that will be subtracted (Argument is negative) or added (Argument is positive) to the entity's hitpoints.
update_hitpoints = function(_modifier){
	if (_modifier == 0) {return;}	// Don't bother with the function if the modifier value is zero.
	hitpoints += floor(_modifier);	// Value is floored so it's always an integer.
	if (hitpoints > maxHitpoints){ // Prevent the player's hitpoints from exceeding the maximum.
		hitpoints = maxHitpoints;
	} else if (hitpoints <= 0){
		hitpoints = 0; // Always set to zero regardless of reserve hitpoints being available or not.
		// Check for reserve hitpoints. If the player has an amount to utilize, it will be added to their
		// hitpoints and whatever amount was put into there is remove from the reserve; reviving the player.
		if (reserveHitpoints > 0){
			update_hitpoints(reserveHitpoints);
			reserveHitpoints -= hitpoints;
			return; // Don't kill off the player.
		}
		// If the player has no reserve hitpoints left to utilize, they will have their state removes, and
		// no longer show up on screen. THe destroyed flag is flipped, but since the player object is set
		// to "invincible" they won't be deleted from the game.
		object_set_next_state(NO_STATE);
		stateFlags &= ~(1 << DRAW_SPRITE);
		stateFlags |= (1 << DESTROYED);
		
		// TODO -- Trigger death effect here.
	}
}

#endregion

#region Aeion gauge functions

/// @description A function that's very similar to "update_hitpoints" but much simpler by comparison. It
/// will simply add the modifier's value to the player's current amount of aeion; limiting it to the range
/// of 0 and whatever their current maximum aeion is.
/// @param {Real}	modifier	The value that will be subtracted (Argument is negative) or added (Argument is positive) to the player's aeion gauge.
update_aeion = function(_modifier){
	if (_modifier == 0) {return;}	// Don't bother with the function if the modifier value is zero.
	curAeion += floor(_modifier);	// Value is floored so it's always an integer.
	if (curAeion > maxAeion)	{curAeion = maxAeion;}
	else if (curAeion < 0)		{curAeion = 0;}
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
			other.vspd = 0.0;
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

/// @description Checks for collision with a liquid and also handle exiting collision with a liquid should
/// the player have already been colliding with a liquid. Also handles dealing damage to the player if the
/// liquid is able to damage the player.
player_liquid_collision = function(){
	// The player is already submerged into a liquid. So, they will be damaged by said liquid if it has
	// the ability to deal damage, and a check will be performed to see if the player is no longer colliding
	// with the liquid they were "submerged" in.
	if (IS_SUBMERGED){
		// Count down the liquid's damage interval and dish out its damage if it should damage the player.
		// Otherwise, ignore this code and just perfrom the collision check below.
		var _id = noone;
		var _damage = 0;
		var _dealsDamage = false;
		with(liquidData){
			_id = liquidID;
			if (damage == 0) {break;}
			damageTimer += DELTA_TIME;
			if (damageTimer >= damageInterval){
				damageTimer -= damageInterval;
				_damage = -damage; // Damage must be negative to take away energy from the player.
			}
			_dealsDamage = true;
		}
		
		// Only bother flashing the player's sprite and dealing with current hitpoints if the liquid in
		// question can cause damage to them. Otherwise, this small chunk of code is skipped.
		if (_dealsDamage){
			if (_damage != 0)		{update_hitpoints(_damage);}
			if (CAN_DRAW_SPRITE)	{stateFlags &= ~(1 << DRAW_SPRITE);}
			else					{stateFlags |= (1 << DRAW_SPRITE);}
		}
		
		// Check if the player is no longer colliding with the liquid they initially entered OR that the
		// value for "_id" wasn't updated past its initial value for some reason. If either is the case,
		// the player will be considered to have emerged from the liquid and will no longer be hindered
		// by it if they didn't have the gravity suit at the time.
		if (_id == noone || !place_meeting(x, y, _id)){
			// Reverse the impact on the player's horizontal and vertical speed/acceleration that the
			// liquid had, but only if they don't have access to the gravity suit currently.
			if (!event_get_flag(FLAG_GRAVITY_SUIT)){
				maxHspdFactor +=	liquidData.maxHspdPenalty;
				maxVspdFactor +=	liquidData.maxVspdPenalty;
				hAccelFactor +=		liquidData.hAccelPenalty;
				vAccelFactor +=		liquidData.vAccelPenalty;
			}
			
			// Clear all of the data from the liquid data struct and reverse the bit that tells the game
			// Samus is submerged in a liquid.
			with(liquidData){
				liquidID =			noone;
				maxHspdPenalty =	0.0;
				maxVspdPenalty =	0.0;
				hAccelPenalty =		0.0;
				vAccelPenalty =		0.0;
				damage =			0;
				damageInterval =	0.0;
				damageTimer	=		0.0;
			}
			stateFlags |= (1 << DRAW_SPRITE);
			stateFlags &= ~(1 << SUBMERGED);
		}
		return;
	}
	
	// Check for a collision with any type of liquid. Since this function takes place after the player's
	// movement function, "instance_place" will be used as hspd and vspd don't need to be considered after
	// the frame's movement has already occurred. If a collision was found, the player will become submerged
	// inside of the liquid that was found by the function.
	var _id = instance_place(x, y, par_liquid);
	if (_id != noone){
		// Store the liquid's parameters in order to reverse their effects once the player exits the liquid.
		with(liquidData){
			liquidID =			_id;
			maxHspdPenalty =	_id.maxHspdPenalty;
			maxVspdPenalty =	_id.maxVspdPenalty;
			hAccelPenalty =		_id.hAccelPenalty;
			vAccelPenalty =		_id.vAccelPenalty;
			damage =			_id.damage;
			damageInterval =	_id.damageInterval;
		}
		
		// Only slow the player down in the liquid if they don't have access to the gravity suit. If they
		// do have the gravity suit, the only effect the liquid will have is initial submersion that slows
		// the player down upon impact with it.
		if (!event_get_flag(FLAG_GRAVITY_SUIT)){
			maxHspdFactor -=	liquidData.maxHspdPenalty;
			maxVspdFactor -=	liquidData.maxVspdPenalty;
			hAccelFactor -=		liquidData.hAccelPenalty;
			vAccelFactor -=		liquidData.vAccelPenalty;
		}
		
		// Regardless of having access to the gravity suit, the player will still impact the water and find
		// themselves submerged, so the relevant flag for that is flipped, and the player's hspd and vspd
		// are drastically reduced to really sell the impact with the liquid.
		stateFlags |= (1 << SUBMERGED);
		vspdRecoil = 0.0;
		hspd *= 0.35;
		vspd *= 0.15;
	}
}

/// @description Handles collisions that can occur between the player and a room warp object. Touching one of
/// these objects will result in all entities in the world briefly pausing while the screen fades in and out
/// to hide the abrupt room change that occurs when using room_goto. The effect unique to room warps is also
/// prepared for execution here.
player_warp_collision = function(){
	warpID = instance_place(x, y, obj_room_warp);
	if (warpID != noone){
		effect_create_screen_fade(HEX_BLACK, 0.1, FADE_PAUSE_FOR_TOGGLE);
		object_set_next_state(state_room_warp);
		
		// 
		var _camera = -1;
		with(CAMERA){
			_camera = camera;
			prevBoundaryID = noone;
			stateFlags &= ~((1 << LOCK_CAMERA_X) | (1 << LOCK_CAMERA_Y) |
							(1 << RESET_TARGET_X) | (1 << RESET_TARGET_Y));
			
		}
		
		// Determine the position to place the surface that contains a snapshot of Samus at. This snapshot
		// is just the last frame of animation she was in, and her arm cannon if it was being shown for said
		// animation. The position needs the camera's value remove from it since it is drawn on the GUI layer.
		var _x = x - sprite_get_xoffset(sprite_index) - camera_get_view_x(_camera);
		var _y = y - sprite_get_yoffset(sprite_index) - camera_get_view_y(_camera);
		with(SCREEN_FADE){
			playerX = _x - SURFACE_OFFSET_X;
			playerY = _y - SURFACE_OFFSET_Y;
		}
	}
}

#endregion

#region Player-specific hit stun function and state

//
__entity_apply_hitstun = entity_apply_hitstun;
/// @description 
/// @param {Real}	duration
/// @param {Real}	damage
entity_apply_hitstun = function(_duration, _damage = 0){
	__entity_apply_hitstun(_duration, _damage);
	curState = NO_STATE; // Implicitly set the current state to nothing in case the hitstun occurred before the player's state executed for the frame.
	stateFlags &= ~((1 << CROUCHING) | (1 << JUMP_ATTACK) | (1 << JUMP_SPIN));
	
	// 
	if (IS_JUMP_ATTACK) {reset_light_source();}
	jumpStartTimer = JUMPSPIN_ANIM_TIME;
	aimReturnTimer = 0.0;

	// 
	hspd = get_max_hspd() * 0.35 * -image_xscale;
	vspd = -2.75;
}

// 
__state_hitstun = state_hitstun;
/// @description 
state_hitstun = function(){
	__state_hitstun();
	if (!IS_HIT_STUNNED){
		// Only bother changing state and manipulation of aiming direction flags when Samus isn't in her morphball
		// form; as that form doesn't need to bother with aiming and proper state setting.
		if (!IN_MORPHBALL){
			object_set_next_state(state_default);
			var _aimingDir = keyboard_check(KEYCODE_GAME_DOWN) - keyboard_check(KEYCODE_GAME_UP);
			if (_aimingDir != 0){
				stateFlags &= ~(1 << AIMING_FRONT);
				if (_aimingDir == 1){ // Sets Samus to aim downward.
					stateFlags |= (1 << AIMING_DOWN);
				} else if (_aimingDir == -1){ // Sets Samus to aim upward; disabling her visor light as well.
					stateFlags |= (1 << AIMING_UP);
					lightComponent.isActive = false;
				}
			}
		}
		return; // Samus is no longer stunned; skip over the state's collision and sprite setting logic.
	}
	
	// 
	apply_gravity();
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_liquid_collision();
	player_warp_collision();
	
	// 
	if (IN_MORPHBALL) {return;}
	var _sState = stateFlags & ((1 << AIMING_DOWN) | (1 << AIMING_UP));
	switch(_sState){
		default: // Samus was aiming forward or not aiming at all at the time of the hit.
			entity_set_sprite(jumpSpriteFw, jumpingMask);
			lightOffsetX = LIGHT_OFFSET_X_GENERAL;
			lightOffsetY = LIGHT_OFFSET_Y_GENERAL;
			break;
		case (1 << AIMING_UP): // Samus was aiming her cannon upward when attacked.
			entity_set_sprite(jumpSpriteUp, jumpingMask);
			lightComponent.isActive = false;
			break;
		case (1 << AIMING_DOWN): // Samus was aiming downward when attacked.
			entity_set_sprite(jumpSpriteDown, jumpingMask);
			lightOffsetX = LIGHT_OFFSET_X_DOWN;
			lightOffsetY = LIGHT_OFFSET_Y_DOWN;
			break;
	}
}

#endregion

#region State function initializations

/// @description Samus's introduction state. From here, all the player will be able to do is press either the 
/// right or left inputs on their in-use input device in order to activate Samus; sending them to her default
/// state after the previous condition is met.
state_intro = function(){
	process_input();
	var _movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (_movement != 0){
		object_set_next_state(state_default);
		entity_set_sprite(standSpriteFw, standingMask);
		image_xscale = _movement;
	}
}

/// @description The state Samus is in whenever a room warp transition is occurring. In this state no input is
/// processed, and no collisions are handled either. Instead, this state is responsible for moving Samus's
/// snapshot overlaying the screen fade towards what her new position is on the game screen. Once the positions
/// of each match, the room transition effect is completed, and Samus will return to her previous state.
state_room_warp = function(){
	var _warpID = warpID;
	var _camera = CAMERA.camera;
	var _targetX = x - sprite_get_xoffset(sprite_index) - camera_get_view_x(_camera) - SURFACE_OFFSET_X;
	var _targetY = y - sprite_get_yoffset(sprite_index) - camera_get_view_y(_camera) - SURFACE_OFFSET_Y;
	with(SCREEN_FADE){
		if (alpha == 1 && alphaTarget == 1){
			// Handle position and room swapping code right before any transition effect code is executed;
			// preventing said code from completely before it even technically began.
			with(_warpID){
				// Prevents crashing and warping if the room provided doesn't exist.
				if (targetRoom == ROOM_INDEX_INVALID){
					PLAYER.warpID = noone;
					other.alphaTarget = 0;
					return;
				}
				
				// Move the player into position, clear out the reference to the warp that is executing
				// the current room warp, and load in the required room. Update the position of the arm
				// cannon as well to compensate for Samus's new position.
				var _x = targetX;
				var _y = targetY;
				with(PLAYER){
					x = _x;
					y = _y;
					warpID = noone;
					
					// Since Samus is in her warping state, the previous state will be used to determine
					// where her arm cannon ends up relative to her position. Otherwise, its position will
					// not change between rooms alongside her.
					var _state = curState;
					curState = lastState;
					armCannon.end_step();
					curState = _state;
				}
				room_goto(targetRoom);
				return; // Ensures the transition effect will begin after everything has been properly set.
			}
			
			// Move the player sprite that exists above the screen fade for a nice effect until it reaches
			// where the object itself is on the screen after the warp.
			var _closeScreenFade = false;
			playerX += (_targetX - playerX) / 5 * DELTA_TIME;
			playerY += (_targetY - playerY) / 5 * DELTA_TIME;
			if (point_distance(playerX, playerY, _targetX, _targetY) <= 1){
				_closeScreenFade = true;
				playerY = _targetX;
				playerY = _targetY;
			}
			// Once the positions match, the screen fade's alpha target is set to fully opaque to close it out.
			if (_closeScreenFade) {alphaTarget = 0;}
		} else if (alpha == 0 && alphaTarget == 0){
			with(other){ // Return Samus to her previous state unpon completion of the screen fade; returning her animation speed to normal as well.
				object_set_next_state(lastState);
				stateFlags &= ~(1 << FREEZE_ANIMATION);
				warpID = noone;
			}
		}
	}
}

/// @description Samus's default or "grounded, but standing" state. She can find herself in this state whenever
/// she is on the ground, but not in her morphball form OR crouching; aiming up doesn't affect anything either
/// than the sprite drawn for Samus while she is standing or walking. From here, she can enter her airbourne
/// state whenever there is no longer a viable floor beneath her, and she can also enter into her crouching
/// state if the player presses the input they've bound to her "down" action.
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
		entity_set_sprite(jumpSpriteFw, standingMask);
		stateFlags &= ~(1 << MOVING);
		aimReturnTimer = 0.0;
		return; // State changed; ignore input and immediately switch over to "airbourne" state.
	}
	
	// Another method of activating Samus's airborune state, but this is done by pressing the input set for
	// jumping. After that, Samus will have her vertical velocity set to whatever her jump height is (Stored
	// as her "maxVspd") and she will either enter a standard jump (Horizontal speed lower than 1) or a
	// somersault jump (Moving fast enough and not firing from Samus's arm cannon).
	if (IS_JUMP_PRESSED && !place_meeting(x, y - 1, par_collider)){
		object_set_next_state(state_airbourne);
		if (abs(hspd) >= 1 && !IS_AIMING){
			if (event_get_flag(FLAG_SCREW_ATTACK)) {stateFlags |= (1 << JUMP_ATTACK);}
			stateFlags |= (1 << JUMP_SPIN);
			effectTimer = JUMP_EFFECT_INTERVAL;
		}
		stateFlags &= ~((1 << GROUNDED) | (1 << MOVING));
		vspd = get_max_vspd();
		return; // State changed; don't process movement/animation within this function.
	}
	
	// Handling horizontal movement for both directions.
	process_horizontal_movement(1.0, 1.0, true, true);
	
	// Entering Samus's crouching state, which lowers her down; shrinking her hitbox a bit vertically and 
	// moving her beam low enough to hit smaller targets. It's accessed by simply pressing the down input.
	if (IS_DOWN_PRESSED){
		object_set_next_state(state_crouching);
		entity_set_sprite(crouchSprite, crouchingMask);
		stateFlags &= ~((1 << AIMING_UP) | (1 << MOVING));
		stateFlags |= (1 << CROUCHING);
		aimReturnTimer = 0.0;
		hspdFraction = 0.0;
		hspd = 0.0;
		lightOffsetY = LIGHT_OFFSET_Y_CROUCH;
		return; // State changed; don't bother continuing with this state function.
	}
	
	// The aiming logic for Samus's default state, which only allows her to aim upward and forward; the latter
	// being the default aiming direction for her when aiming inputs (Up/down, respectively) aren't pressed.
	if (IS_UP_PRESSED){
		stateFlags &= ~(1 << AIMING_FRONT);
		stateFlags |= (1 << AIMING_UP);
		lightComponent.isActive = false;
	} else if (IS_UP_RELEASED){
		stateFlags &= ~(1 << AIMING_UP);
		lightComponent.isActive = true;
	}
	
	// Another way of aiming Samus up that can only happen when she very recently exited her crouching state.
	// In short, it checks if the player is holding down the up input, which handles both exiting crouch AND
	// aiming up in order to prevent Samus instantly snapping to her upward aiming substate. This creates a 
	// very short buffer for her to aim forward before snapping upward (As long as the up key is held for the
	// required duration of this "aim switch buffer").
	if (!IS_AIMING_UP && IS_UP_HELD){
		aimSwitchTimer += DELTA_TIME;
		if (aimSwitchTimer >= AIM_SWITCH_TIME){
			lightComponent.isActive = false;
			stateFlags &= ~(1 << AIMING_FRONT);
			stateFlags |= (1 << AIMING_UP);
			aimSwitchTimer = 0.0;
		}
	} else{
		aimSwitchTimer = 0.0;
	}
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();
	
	// Use the general offset position for the visor light's current x-position.
	lightOffsetX = LIGHT_OFFSET_X_GENERAL;
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	player_warp_collision();
	
	// Setting a walking sprite to use if Samus is moving (Determined by the value of the bit flag "IS_WALKING"
	// at the end of the frame). She can have three possible animations for this substate: walking normally, 
	// with her beam aiming forward, or with her beam aiming upward.
	var _sState = stateFlags & ((1 << AIMING_FRONT) | (1 << AIMING_UP));
	if (IS_MOVING){
		var _animSpeed = abs(hspd) / maxHspd;
		switch(_sState){
			default:					entity_set_sprite(walkSpriteFw,	standingMask, _animSpeed);		break;
			case (1 << AIMING_FRONT):	entity_set_sprite(walkSpriteFwExt, standingMask, _animSpeed);	break;
			case (1 << AIMING_UP):		entity_set_sprite(walkSpriteUp,	standingMask, _animSpeed);		break;
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
		// Reset the light if Samus was in her screw attack animation to return her ambient light sources
		// ack to being utilized as illumination for her visor.
		if (IS_JUMP_ATTACK) {reset_light_source();}
		
		// Reset all variables that were altered by the airbourne state and no longer required. Also reset
		// Samus's horizontal velocity to make it add to the impact of Samus landing.
		stateFlags &= ~((1 << JUMP_SPIN) | (1 << JUMP_ATTACK) | (1 << AIMING_DOWN));
		jumpStartTimer = 0.0;
		aimReturnTimer = 0.0;
		hspdFraction = 0.0;
		hspd = 0.0;
		
		// Offset Samus by the difference between the bottom of her collision mask while airbourne and her
		// collision mask for standing on the ground; ensuring she will be colliding perfectly with the floor
		// beneath her.
		var _bboxBottom = bbox_bottom;
		mask_index = standingMask;
		y -= (bbox_bottom - _bboxBottom);
		
		// Check collision to see if Samus has something above her head and directly below her. If she does, 
		// switch over to her crouching state instead of her default.
		if (place_meeting(x, y, par_collider) && place_meeting(x, y + 1, par_collider)){
			object_set_next_state(state_crouching);
			entity_set_sprite(crouchSprite, crouchingMask);
			lightOffsetY = LIGHT_OFFSET_Y_CROUCH;
		} else{
			object_set_next_state(state_default);
			lightOffsetY = LIGHT_OFFSET_Y_GENERAL;
		}
		return; // State has changed; exit the function prematurely.
	}
	
	// When the jump input is activated, three possibilities can occur whilst airborune. The first is a check
	// for the double jump ability, which enables Samus to jump once more in the air regardless of if she's
	// somersaulting or not. The second will activate that somersaulting jump if she's moving horizontally 
	// and not aiming. Finally, a check for the space jump ability will occur if she's already in that 
	// somersaulting jump; allowing her to jump again indefinitely while in that same jump.
	if (IS_JUMP_PRESSED){
		if (!IS_AIMING_DOWN && !IS_AIMING_UP){ // Samus cannot be aiming in any direction to enable somersaulting in the air and her space jump.
			if (!IS_JUMP_SPIN){ // Entering a somersault jump when airbourne.
				if (event_get_flag(FLAG_SCREW_ATTACK)) {stateFlags |= (1 << JUMP_ATTACK);}
				stateFlags &= ~(1 << AIMING_FRONT);
				stateFlags |= (1 << JUMP_SPIN);
				hspd = get_max_hspd() * image_xscale;
				aimReturnTimer = 0.0;
				effectTimer = JUMP_EFFECT_INTERVAL;
			} else if (vspd >= 2 && event_get_flag(FLAG_SPACE_JUMP)){ // Utilizing Samus's Space Jump ability (Overwrites the double jump).
				vspd = get_max_vspd();
			}
		}
	}
	if (IS_JUMP_RELEASED && vspd < 0) {vspd *= 0.5;}
	
	// 
	var _hspdFactor = 1.0;
	if (abs(hspd) < get_max_hspd() && !IS_JUMP_SPIN) {_hspdFactor = 0.7;}
	process_horizontal_movement(_hspdFactor, 0.5, false, false);
	if (movement != 0){
		if (IS_AIMING_DOWN && !IS_DOWN_HELD){
			aimReturnTimer += DELTA_TIME;
			if (aimReturnTimer >= AIM_SWITCH_TIME){
				stateFlags &= ~(1 << AIMING_DOWN);
				aimReturnTimer = 0.0;
			}
		}
	} else{
		aimReturnTimer = 0.0;
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
		if (!IS_AIMING_DOWN){ // Aiming upward until the player releases their up input.
			stateFlags &= ~((1 << AIMING_FRONT) | (1 << JUMP_SPIN) | (1 << JUMP_ATTACK));
			stateFlags |= (1 << AIMING_UP);
			lightComponent.isActive = false;
		} else{ // Exiting from aiming downward.
			stateFlags &= ~(1 << AIMING_DOWN);
			lightOffsetX = LIGHT_OFFSET_X_GENERAL; // Reset visor light offset.
			lightOffsetY = LIGHT_OFFSET_Y_GENERAL;
		}
	} else if (_vInput == 1){
		if (!IS_AIMING_DOWN){ // Entering a downward aiming state.
			var _jumpAttack = stateFlags & (1 << JUMP_ATTACK);
			stateFlags &= ~((1 << AIMING_FRONT) | (1 << AIMING_UP) | (1 << JUMP_SPIN) | (1 << JUMP_ATTACK));
			stateFlags |= (1 << AIMING_DOWN);
			if (_jumpAttack) {reset_light_source();}
			lightOffsetX = LIGHT_OFFSET_X_DOWN;
			lightOffsetY = LIGHT_OFFSET_Y_DOWN;
		} else if (event_get_flag(FLAG_MORPHBALL)){ // Entering morphball mode while in the air.
			object_set_next_state(state_enter_morphball);
			var _bboxBottom = bbox_bottom;
			entity_set_sprite(ballEnterSprite, morphballMask);
			y -= bbox_bottom - _bboxBottom;
			jumpStartTimer = 0.0;
			return;
		}
	} else if (IS_UP_RELEASED){ // Stopping Samus from aiming upward.
		stateFlags &= ~(1 << AIMING_UP);
		lightComponent.isActive = true;
	}
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();
	
	// The light effect that occurs when Samus is using her screw attack, which will vastly increase the size
	// and brightness of the light; moving it to the center of her animation for the duration. The visor light
	// is replaced by this light.
	var _jumpattack = IS_JUMP_ATTACK;
	var _jumpspin = IS_JUMP_SPIN;
	with(lightComponent){
		if (_jumpattack){
			set_properties(80 + irandom_range(-10, 10), 
							choose(HEX_LIGHT_GREEN, HEX_LIGHT_BLUE, HEX_LIGHT_PURPLE, HEX_WHITE), 
							0.9 + random_range(-0.2, 0.2));
		}
	}
	if (_jumpattack){ // Position for the screw attack's flashing light effect.
		lightOffsetX = LIGHT_OFFSET_X_ATTACK;
		lightOffsetY = LIGHT_OFFSET_Y_ATTACK;
	}
	
	// When Samus isn't using her screw attack, the ambient light position is updated to match Samus's visor's
	// position during her somersaulting jump animation depending on the current frame of the animation that
	// is visible on-screen.
	var _animFinished = jumpStartTimer == JUMPSPIN_ANIM_TIME;
	if (!_jumpspin){ // No changes to offset of light when not spinning
		if (lightOffsetX == 0) {reset_light_source();}
		lightOffsetX = LIGHT_OFFSET_X_GENERAL;
	} else if (_animFinished && !_jumpattack){ 
		// Update offset of the light to match where Samus's visor is for each frame of her somersault.
		switch(floor(imageIndex)){
			case 0: // Visor is on top of the image.
				lightOffsetX = 3 * image_xscale;
				lightOffsetY = -26;
				break;
			case 1: // Visor is to the right of the image.
				lightOffsetX = 6 * image_xscale;
				lightOffsetY = -16;
				break;
			case 2: // Visor is on the bottom of the image.
				lightOffsetX = -5 * image_xscale;
				lightOffsetY = -14;
				break;
			case 3: // Visor is on the left of the image.
				lightOffsetX = -7 * image_xscale;
				lightOffsetY = -24;
		}
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_liquid_collision();
	player_warp_collision();
	
	// Producing the ghosting effect for Samus's somersault, which leaves an instance of Samus that quickly
	// fades out. This effect is created at a regular interval until she is no longer somersaulting.
	if (sprite_index == jumpSpriteSpin){
		effectTimer += DELTA_TIME;
		if (effectTimer >= JUMP_EFFECT_INTERVAL){
			ds_list_add(jumpEffectID, create_player_jump_effect(x, y, sprite_index, floor(imageIndex), image_xscale));
			effectTimer = 0.0;
		}
	}
	
	// Counting down the time that prevents Samus from somersalting or showing her jump sprites (Excluding the
	// downward facing jump sprite) in order to display their respective intro animations, which are all based
	// on this timer's value against specific macro values.
	if (!_animFinished){
		jumpStartTimer += DELTA_TIME;
		if (jumpStartTimer >= JUMPSPIN_ANIM_TIME) {jumpStartTimer = JUMPSPIN_ANIM_TIME;}
	}
	
	// Assign Samus's jumping animation, which is determined by her aiming substates, and also her "jumpspin"
	// substate; the latter being applied based on if she was moving before the jump was entered OR if the
	// jump button is pressed while airbourne and not somersaulting. Aside from that, the sprite will be
	// assigned based on what her aiming direction is: upward, downward (Unique to jumping), or forward.
	var _sState = stateFlags & ((1 << AIMING_FRONT) | (1 << AIMING_UP) | (1 << AIMING_DOWN) | (1 << JUMP_SPIN));
	if (_sState == (1 << JUMP_SPIN)){ // Set to Samus's somersault or somersault intro animation.
		if (jumpStartTimer == JUMPSPIN_ANIM_TIME){
			entity_set_sprite(jumpSpriteSpin, jumpingMask, 1, 0);
		} else{ // Determine which of the two somersaulting entrance frames to set Samus to based on the timer's value.
			if (jumpStartTimer < JUMPSPIN_ANIM_TIME / 2) {entity_set_sprite(walkSpriteFw, standingMask);}
			else {entity_set_sprite(jumpSpriteFw, jumpingMask);}
		}
		return; // Don't bother checking for other animations.
	}
		
	// Applying one of Samus's non-transitional jumping sprites for the current frame; meaning she's
	// already finished execution the jump's intro animation.
	if (jumpStartTimer >= JUMP_ANIM_TIME || vspd >= 0){
		switch(_sState){
			default:					entity_set_sprite(jumpSpriteFw, jumpingMask);	break;
			case (1 << AIMING_UP):		entity_set_sprite(jumpSpriteUp, jumpingMask);	break;
			case (1 << AIMING_DOWN):	entity_set_sprite(jumpSpriteDown, jumpingMask);	break;
		}
		return; // No need to set an intro animation sprite, so return early.
	}
		
	// Samus is in her transitional animation between standing and jumping, so apply the animation
	// frame that matches with the direction she's aiming her arm cannon (Excluding aiming down).
	switch(_sState){
		default:					entity_set_sprite(walkSpriteFw, standingMask, 0); break;
		case (1 << AIMING_UP):		entity_set_sprite(walkSpriteUp, standingMask, 0); break;
	}
	imageIndex = 0; // Always use the first frame of animation during the transition.
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
	movement = IS_RIGHT_HELD - IS_LEFT_HELD;
	if (movement != 0){
		standingTimer += DELTA_TIME;
		if (standingTimer >= STAND_UP_TIME){
			crouch_to_standing();
			standingTimer = 0.0;
		}
		image_xscale = movement;
	} else{ // Reset timer for making Samus stand through left or right input when they are released early.
		standingTimer = 0.0;
	}
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();
	
	// Use the general offset position for the visor light's current x-position.
	lightOffsetX = LIGHT_OFFSET_X_GENERAL;
}

/// @description A passing state that will play Samus's one-frame animation for entering her morphball form.
/// The time for this transition being determined by the value of the "MORPHBALL_ANIM_TIME" constant. After
/// that amount of time has elapsed, she'll either enter or exit morphball depending on what state she was in
/// previously.
state_enter_morphball = function(){
	mBallEnterTimer += DELTA_TIME;
	if (mBallEnterTimer >= MORPHBALL_ANIM_TIME){
		mBallEnterTimer = 0.0;
		
		// ENTERING MORPHBALL -- Occurs when Samus was previously in her crouching or airbourne states, 
		// respectively. She will be set to her default morphball state, and her substate flags will be 
		// updated to reflect her new state swap.
		if (stateFlags & (1 << MORPHBALL) == 0){
			object_set_next_state(state_morphball);
			entity_set_sprite(morphballSprite, morphballMask);
			stateFlags &= ~((1 << AIMING_DOWN) | (1 << CROUCHING));
			stateFlags |= (1 << MORPHBALL);
			lightComponent.isActive = false;
			curWeapon = curBeam;
			return;
		}
		
		// EXITING MORPHBALL -- Occurs when Samus was in her default morphball state before entering this one.
		// She will be set to either her airbourne state if she was in the air when she exited her morphball
		// mode, or her crouching state if she was on the ground.
		stateFlags &= ~(1 << MORPHBALL);
		reset_light_source();
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
		standingTimer = 0.0;
		hspdFraction = 0.0;
		hspd = 0.0;
		lightOffsetY = LIGHT_OFFSET_Y_CROUCH;
	} else{ // Position ambient light at the visor's position in the sprite.
		lightOffsetX = LIGHT_OFFSET_X_GENERAL;
		lightOffsetY = LIGHT_OFFSET_Y_MBALL;
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	player_warp_collision();
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
			vspdRecoil = 0.0;
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
	process_horizontal_movement(1.0, 0.6, IS_GROUNDED, IS_GROUNDED);
	
	// Exiting out of morphball mode, which will call the function that checks for a collision directly above
	// Samus's head. If there's a collision, she'll be unable to transform back into her standard form.
	if (IS_UP_PRESSED){
		morphball_to_crouch();
		return; // State potentially changed; exit the current state function prematurely.
	}
	
	// Using the standard bombs (If the auxilliary weapon input isn't pressed OR the player doesn't have
	// access to the power bombs yet) or power bombs if the player has access to them. Both require the
	// timer for bomb use to be zero, and both will set the timer to different amount to differentiate
	// how often each can be used.
	if (IS_USE_PRESSED && bombDropTimer == 0){
		if (IS_ALT_WEAPON_HELD && event_get_flag(FLAG_POWER_BOMBS) && numPowerBombs > 0){ // Deploying a power bomb.
			var _id = instance_create_object(x, y - 5, obj_player_power_bomb, depth - 1);
			var _maxHitpoints = 0;
			with(_id){ // Copy the value for maximum hitpoints for the bomb drop timer.
				_maxHitpoints = maxHitpoints;
				initialize(state_default);
			}
			bombDropTimer = _maxHitpoints + 30; // Lasts half a second longer than the power bomb explosion's full length.
			numPowerBombs--;
		} else if (event_get_flag(FLAG_BOMBS) && instance_number(obj_player_bomb) < MAX_STANDARD_BOMBS){ // Deploying a standard bomb.
			var _id = instance_create_object(x, y - 5, obj_player_bomb, depth - 1);
			with(_id) {initialize(state_default);}
			bombDropTimer = BOMB_DROP_RATE;
		}
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
	player_warp_collision();
	
	// Assign the morphball's sprite, and update its image speed based on whatever its current horizontal
	// movement factor is set to (Ex. A factor of 0.5 would make the morphball animate at half its normal
	// speed, and so on).
	entity_set_sprite(morphballSprite, morphballMask, animSpeed);
}

#endregion

// SET A UNIQUE COLOR FOR SAMUS'S BOUNDING BOX (FOR DEBUGGING ONLY)
collisionMaskColor = HEX_LIGHT_BLUE;

temp = 0.0;