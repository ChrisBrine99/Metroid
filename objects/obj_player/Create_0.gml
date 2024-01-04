#region Macros that are useful/related to obj_player

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the "stateFlags" variable. These represent states that don't need to be	   //
//	tied to a specific function due to these states being allowed across multiple of those main states.	   //
// ------------------------------------------------------------------------------------------------------- //

// --- Movement Substates --- //
#macro	PLYR_MOVING				0x00000001
#macro	PLYR_CROUCHED			0x00000002
#macro	PLYR_SUBMERGED			0x00000004
#macro	PLYR_SOMERSAULT			0x00000008
#macro	PLYR_MORPHBALL			0x00000010
// --- Weapon Substates --- //
#macro	PLYR_SCREWATK			0x00000040
#macro	PLYR_FIRING_CANNON		0x00000080
// --- Aiming Substates --- //
#macro	PLYR_AIMING_UP			0x00000100
#macro	PLYR_AIMING_DOWN		0x00000200
// --- Aeion Substates --- //
#macro	PLYR_ESHIELD_ACTIVE		0x00000400
#macro	PLYR_PSHIFT_ACTIVE		0x00000800
// --- Miscellaneous Substates --- //
#macro	PLYR_PLAY_INTRO_SONG	0x00020000
#macro	PLYR_SLOW_AIR_MOVEMENT	0x00040000
#macro	PLYR_SPRITE_FLICKER		0x00080000
#macro	PLYR_BEAM_VISIBLE		0x00100000
// NOTE -- Bits 0x00200000 and greater are already in use by default dynamic entity substate flags.

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check if Samus is currently within one of these substates.   //
// ------------------------------------------------------------------------------------------------------- //

// --- Movement Substate Checks --- //
#macro	PLYR_IS_MOVING			(stateFlags & PLYR_MOVING)
#macro	PLYR_IS_CROUCHED		(stateFlags & PLYR_CROUCHED)
#macro	PLYR_IS_SUBMERGED		(stateFlags & PLYR_SUBMERGED)
#macro	PLYR_IN_MORPHBALL		(stateFlags & PLYR_MORPHBALL)
#macro	PLYR_IN_SOMERSAULT		(stateFlags & PLYR_SOMERSAULT)
// --- Weapon Substate Checks --- //
#macro	PLYR_IN_SCREWATK		(stateFlags & PLYR_SCREWATK)
#macro	PLYR_IS_USING_CANNON	(stateFlags & PLYR_FIRING_CANNON)
// --- Aiming Substate Checks --- //
#macro	PLYR_IS_AIMING_UP		(stateFlags & PLYR_AIMING_UP)
#macro	PLYR_IS_AIMING_DOWN		(stateFlags & PLYR_AIMING_DOWN)
#macro	PLYR_IS_AIMING			((stateFlags & PLYR_AIMING_UP) | (stateFlags & PLYR_AIMING_DOWN) | \
									(stateFlags & PLYR_FIRING_CANNON)) // <-- Substate also counts as aiming
// --- Aeion Ability Substate Checks --- //
#macro	PLYR_USING_ESHIELD		(stateFlags & PLYR_ESHIELD_ACTIVE)
#macro	PLYR_USING_PSHIFT		(stateFlags & PLYR_PSHIFT_ACTIVE)
/// --- Miscellaneous Substate Checks --- //
#macro	PLYR_CAN_SPRITE_FLICKER	(stateFlags	& PLYR_SPRITE_FLICKER)
#macro	PLYR_IS_BEAM_VISIBLE	(stateFlags & PLYR_BEAM_VISIBLE)
#macro	PLYR_IS_MOVING_SLOW		(stateFlags & PLYR_SLOW_AIR_MOVEMENT)

// ------------------------------------------------------------------------------------------------------- //
//	Values for the bits within the variables "inputFlags" and "prevInputFlags" that correspond to the	   //
//	input that they are tied to; where a 1 is stored should the keyboard_check calls in the process_input  //
//	function return true or a 0 if those checks return false for each input.							   //
// ------------------------------------------------------------------------------------------------------- //

// --- Movement/Aiming Inputs --- //
#macro	PLYR_RIGHT				0x00000001
#macro	PLYR_LEFT				0x00000002
#macro	PLYR_UP					0x00000004
#macro	PLYR_DOWN				0x00000008
#macro	PLYR_JUMP				0x00000010
// --- Beam/Bomb Inputs --- //
#macro	PLYR_USE_WEAPON			0x00000020
#macro	PLYR_SWAP_WEAPON		0x00000040
// --- Beam Type Shortcut Inputs --- //
#macro	PLYR_POWBEAM			0x00000080
#macro	PLYR_ICEBEAM			0x00000100
#macro	PLYR_WAVBEAM			0x00000200
#macro	PLYR_PLSBEAM			0x00000400
// --- Missile Type Shortcut Inputs --- //
#macro	PLYR_REGMISSILE			0x00000800
#macro	PLYR_ICEMISSILE			0x00001000
#macro	PLYR_SHKMISSILE			0x00002000
// --- Missile/Power Bomb Activation Input --- //
#macro	PLYR_ALT_WEAPON			0x00004000
// --- Aeion Ability Inputs --- //
#macro	PLYR_ENERGY_SHIELD		0x00008000
#macro	PLYR_PHASE_SHIFT		0x00010000

// ------------------------------------------------------------------------------------------------------- //
//	Macros that condense the code required to check if a given input has been pressed/released or is 	   //
//	actively being held down by the player.																   //
// ------------------------------------------------------------------------------------------------------- //

// --- Horizontal Inputs (Hold) --- //
#macro	PLYR_RIGHT_HELD			((inputFlags & PLYR_RIGHT)	!= 0)
#macro	PLYR_LEFT_HELD			((inputFlags & PLYR_LEFT)	!= 0)
// --- Up Inputs (Hold/Press/Release) --- //
#macro	PLYR_UP_HELD			(inputFlags & PLYR_UP)
#macro	PLYR_UP_PRESSED			(inputFlags & PLYR_UP && !(prevInputFlags & PLYR_UP))
#macro	PLYR_UP_RELEASED		(!(inputFlags & PLYR_UP) && prevInputFlags & PLYR_UP)
// --- Down Inputs (Hold/Press/Release) --- //
#macro	PLYR_DOWN_HELD			(inputFlags & PLYR_DOWN)
#macro	PLYR_DOWN_PRESSED		(inputFlags & PLYR_DOWN && !(prevInputFlags & PLYR_DOWN))
#macro	PLYR_DOWN_RELEASED		(!(inputFlags & PLYR_DOWN) && prevInputFlags & PLYR_DOWN)
// --- Jump Inputs (Press/Release) --- //
#macro	PLYR_JUMP_PRESSED		(inputFlags & PLYR_JUMP && !(prevInputFlags & PLYR_JUMP))
#macro	PLYR_JUMP_RELEASED		(!(inputFlags & PLYR_JUMP) && prevInputFlags & PLYR_JUMP)
// --- Arm Cannon/Bomb Inputs (Hold/Press/Release) --- //
#macro	PLYR_USE_HELD			(inputFlags & PLYR_USE_WEAPON)
#macro	PLYR_USE_PRESSED		(inputFlags & PLYR_USE_WEAPON && !(prevInputFlags & PLYR_USE_WEAPON))
#macro	PLYR_USE_RELEASED		(!(inputFlags & PLYR_USE_WEAPON) && prevInputFlags & PLYR_USE_WEAPON)
// --- Beam Shortcut Inputs (Hold/Press) --- //
#macro	PLYR_SWAP_WEAPON_HELD	(inputFlags & PLYR_SWAP_WEAPON)
#macro	PLYR_POWBEAM_PRESSED	(inputFlags & PLYR_POWBEAM && !(prevInputFlags & PLYR_POWBEAM))
#macro	PLYR_ICEBEAM_PRESSED	(inputFlags & PLYR_ICEBEAM && !(prevInputFlags & PLYR_ICEBEAM))
#macro	PLYR_WAVBEAM_PRESSED	(inputFlags & PLYR_WAVBEAM && !(prevInputFlags & PLYR_WAVBEAM))
#macro	PLYR_PLSBEAM_PRESSED	(inputFlags & PLYR_PLSBEAM && !(prevInputFlags & PLYR_PLSBEAM))
// --- Missile Shortcut Inputs (Press) --- //
#macro	PLYR_REGMISSILE_PRESSED	(inputFlags & PLYR_REGMISSILE && !(prevInputFlags & PLYR_REGMISSILE))
#macro	PLYR_ICEMISSILE_PRESSED	(inputFlags & PLYR_ICEMISSILE && !(prevInputFlags & PLYR_ICEMISSILE))
#macro	PLYR_SHKMISSILE_PRESSED	(inputFlags & PLYR_SHKMISSILE && !(prevInputFlags & PLYR_SHKMISSILE))
// --- Missile/Power Bomb Activation Inputs (Hold/Press) --- //
#macro	PLYR_ALT_WEAPON_HELD	(inputFlags & PLYR_ALT_WEAPON)
#macro	PLYR_ALT_WEAPON_PRESSED	(inputFlags & PLYR_ALT_WEAPON && !(prevInputFlags & PLYR_ALT_WEAPON))
// --- Aeion Ability Inputs (Press) --- //
#macro	PLYR_ESHIELD_PRESSED	(inputFlags & PLYR_ENERGY_SHIELD && !(prevInputFlags & PLYR_ENERGY_SHIELD))
#macro	PLYR_PSHIFT_PRESSED		(inputFlags & PLYR_PHASE_SHIFT && !(prevInputFlags & PLYR_ENERGY_SHIELD))

// ------------------------------------------------------------------------------------------------------- //
//	Two unique "substate" flags that are only utilized when creating a projectile object based on the	   //
//	beam/missile Samus currently has equipped. These can be the 31st and 32nd bits because only five bits  //
//	from "stateFlags" (Moving, crouching, aiming up, aiming down, and grounded) are carried over into this //
//	temporary substate flag variable.																	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_FACING_RIGHT		0x40000000
#macro	PLYR_FACING_LEFT		0x80000000

// ------------------------------------------------------------------------------------------------------- //
//	Values that correspond to various lengths of time that prevent/enable/disable certain characteristics  //
//	for Samus, the legnth of state transitions and code-based animations, as well as any other logic that  //
//	requires a specific interval of time for its functionality. Note that 60 units is roughly one second.  //
// ------------------------------------------------------------------------------------------------------- //

// --- General Values --- //
#macro	PLYR_LOWER_CANNON_TIME	20.0	// How long after cannon was fired that Samus keeps her beam aimed forward.
#macro	PLYR_AIM_BUFFER_TIME	8.0		// Time before Samus can aim upward after standing up from a crouch.
#macro	PLYR_STAND_UP_TIME		10.0	// How long a horizontal movement input must be pressed while crouching to make Samus stand.
// --- Animation Values --- //
#macro	PLYR_JUMP_START_TIME	5.0		// Time that the first "frame" of the jump animation will last for.
#macro	PLYR_FLIP_START_TIME	8.0		// How long in frames before Samus begins somersaulting after starting a jump.
#macro	PLYR_CHARGE_LOOP_TIME	80.0	// Time before Samus's charge effect begins its two frame loop.
#macro	PLYR_ENTER_BALL_TIME	2.0		// How long Samus will be in her "enter" morphball animation for.
#macro	PLYR_EXIT_BALL_TIME		2.0		// This value matches Samus's enter morphball animation length.
// --- Weapon Values --- //
#macro	PLYR_CHARGE_TIME		55.0	// Minimum amount of time the beam must be charged for before the fired beam is its charged variant.
#macro	PLYR_BEAM_SWAP_TIME		15.0	// Time before Samus can use the beam she just swapped to.
#macro	PLYR_MISSILE_SWAP_TIME	10.0	// Samus as above but for when Samus is using missiles.
// --- Effect Values --- //
#macro	PLYR_JUMP_INTERVAL		2.5		// Time between ghosting effects spawning during a somersault jump.
#macro	PLYR_SHIFT_INTERVAL		1.75	// Time between "ghosts" of Samus appearing during a phase shift.
#macro	PLYR_HIT_INTERVAL		2.0		// How often Samus swaps between visible and not during damage recovery.
// --- Misc. Values --- //
#macro	PLYR_STEP_INTERVAL		11.0	// Duration between each of Samus' footsteps.

// ------------------------------------------------------------------------------------------------------- //
//	Values for Samus's jumping capabilities; her starting jump strength, the upgraded strength of her 	   //
//	jump after acquiring the High Jump Boots, and her maximum falling speed due to gravity.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_BASE_JUMP		   -5.4
#macro	PLYR_UPGRADED_JUMP	   -7.2
#macro	PLYR_MAX_FALL_SPEED		8.0

// ------------------------------------------------------------------------------------------------------- //
//	These values determine what percentage of Samus' current hspd will actually count towards her		   //
//	movement for a given frame. These penalties depend on things like if Samus is in the air or if she is  //
//	somersaulting but hit something or changed directions, and so on.									   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_JUMP_HSPD_FACTOR	0.45
#macro	PLYR_SPIN_HSPD_FACTOR	0.75

// ------------------------------------------------------------------------------------------------------- //
//	The values here correspond to Samus's currently equipped weapon for her arm cannon. When the value 	   //
//	stored within the "curWeapon" variable is equal to a given value, it will cause that beam/missile to   //
//	be fired when the player uses Samus's arm cannon.													   //
// ------------------------------------------------------------------------------------------------------- //

// --- Beam ID Values --- //
#macro	WEAPON_POWER_BEAM		0x00000001
#macro	WEAPON_ICE_BEAM			0x00000002
#macro	WEAPON_WAVE_BEAM		0x00000003
#macro	WEAPON_PLASMA_BEAM		0x00000004
// --- Missile ID Values --- //
#macro	WEAPON_REG_MISSILE		0x80000001
#macro	WEAPON_ICE_MISSILE		0x80000002
#macro	WEAPON_SHOCK_MISSILE	0x80000003
// NOTE -- These values are used to represent a fired projectile's internal ID as well.

// ------------------------------------------------------------------------------------------------------- //
//	Values that represent how long in "frames" (60 frames == 1 second) that the player must wait before	   //
//	Samus can deploy another standard bomb while she's in her morphball form, the maximum number of	those  //
//	bombs that can be deployed at once, and how high Samus is sent vertically by the bomb's explosion.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_BOMB_SET_INTERVAL	5.0
#macro	PLYR_MAX_BOMBS			3
#macro	PLYR_BOMB_JUMP_VSPD	   -4.0

// ------------------------------------------------------------------------------------------------------- //
//	Determines how fast Samus must be falling downward in order to have the Morphball bounce back up on	   //
//	impact with the ground (This bounce doesn't occur while in water without the Gravity Suit equipped).   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_MBALL_BOUNCE_VSPD	6.0

// ------------------------------------------------------------------------------------------------------- //
//	Simply holds the value for the length of the array storing "obj_player_ghost_effect" structs so the	   //
//	number isn't hardcoded all over the place.
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_NUM_GHOST_EFFECTS	8

// ------------------------------------------------------------------------------------------------------- //
//	Characteristics about the Phase Shift aeion ability; its speed (Only applies to the x axis since the   //
//	phase shift moves Samus horizontally), cooldown before another aeion ability can be used, distance 	   //
//	that Samus moves because of the ability's use, and the aeion energy cost to activate the ability.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_PSHIFT_SPEED		12.0
#macro	PLYR_PSHIFT_COOLDOWN	30.0
#macro	PLYR_PSHIFT_DISTANCE	80
#macro	PLYR_PSHIFT_COST		50

// ------------------------------------------------------------------------------------------------------- //
//	Macros that store values for Samus's light source struct, which swaps between representing her visor,  //
//	the screw attack, and so on. The radius, color (Doesn't need a macro to represent its value(s) as 	   //
//  there are already a plethora of macros for various colors), and strength are altered for each one.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LGHT_VISOR_RADIUS		8.0
#macro	LGHT_VISOR_STRENGTH		0.5
#macro	LGHT_SCREWATK_RADIUS	80.0
#macro	LGHT_SCREWATK_STRENGTH	0.9
#macro	LGHT_PSHIFT_RADIUS		120.0
#macro	LGHT_PSHIFT_STRENGTH	1.0

// ------------------------------------------------------------------------------------------------------- //
//	Positional offsets relative to Samus's current position (This is located at her feet) to place the 	   //
//	light component at. These values are swapped in and out as required based on what Samus is doing.	   //
// ------------------------------------------------------------------------------------------------------- //

// --- Coordinates for Visor While Standing/Walking --- //
#macro	LGHT_VISOR_X_GENERAL	4 * image_xscale
#macro	LGHT_VISOR_Y_GENERAL   -33
// --- Coordinates for Visor While Aiming Down --- //
#macro	LGHT_VISOR_X_DOWN		6 * image_xscale
#macro	LGHT_VISOR_Y_DOWN	   -19
// --- Coordinates for Visor While Crouching --- //
#macro	LGHT_VISOR_X_CROUCH		3 * image_xscale
#macro	LGHT_VISOR_Y_CROUCH	   -23
// --- Coordinates for Visor During Morphball Enter/Exit Animation --- //
#macro	LGHT_VISOR_X_TRANSFORM	2 * image_xscale
#macro	LGHT_VISOR_Y_TRANSFORM -18
// --- Coordinates for Visor While Airborne --- //
#macro	LGHT_VISOR_X_JUMP		4 * image_xscale
#macro	LGHT_VISOR_Y_JUMP	   -24
// --- Coordinates for Visor During Somersault Animation --- //
#macro	LGHT_VISOR_X_FLIP0		3 * image_xscale
#macro	LGHT_VISOR_Y_FLIP0	   -21
#macro	LGHT_VISOR_X_FLIP1		6 * image_xscale
#macro	LGHT_VISOR_Y_FLIP1	   -11
#macro	LGHT_VISOR_X_FLIP2	   -5 * image_xscale
#macro	LGHT_VISOR_Y_FLIP2	   -9
#macro	LGHT_VISOR_X_FLIP3	   -7 * image_xscale
#macro	LGHT_VISOR_Y_FLIP3	   -19
// --- Coordinates for Screw Attack Flashes --- //
#macro	LGHT_SCREWATK_X			0
#macro	LGHT_SCREWATK_Y		   -12

// ------------------------------------------------------------------------------------------------------- //
//	Constants for the volume of sound effects that Samus can have play when she performs various actions.  //
//	These values will reduce the sound relative to the current global for all sound effects in the game.   //
// ------------------------------------------------------------------------------------------------------- //

#macro	PLYR_STEP_MIN_VOLUME	0.12
#macro	PLYR_STEP_MAX_VOLUME	0.18
#macro	PLYR_TRANSFORM_VOLUME	0.5
#macro	PLYR_AIMCANNON_VOLUME	0.2
#macro	PLYR_JUMPSTART_VOLUME	0.7
#macro	PLYR_SOMERSAULT_VOLUME	0.3
#macro	PLYR_SCREWATK_VOLUME	0.2
#macro	PLYR_LAND_VOLUME		0.15
#macro	PLYR_MORPHLAND_VOLUME	0.35

// ------------------------------------------------------------------------------------------------------- //
//	Maximum values for Samus's active + reserve energy, aeion, missile ammunition, and held power bombs.   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ENERGY_LIMIT			1299
#macro	RESERVE_ENERGY_LIMIT	500
#macro	AEION_LIMIT				100
#macro	MISSILE_LIMIT			250
#macro	POWER_BOMB_LIMIT		15

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Samus's physics characteristics; her maximum walking speed (maxHspd), as well as her acceleration on that
// axis, and jumping power (maxVspd), as well as her acceleration vertically (gravity).
maxHspd = 2.2;
maxVspd = PLYR_BASE_JUMP;
hAccel	= 0.3;
vAccel	= 0.25;

// Set Samus's recovery time to one second after she's been hit. This means that she'll get that second of
// invincibility plus whatever the hitstun timer was from the attack she sustained.
recoveryLength = 60.0;

// Samus's ability to take damage (Known as her "energy" in all official games) from hazards. The higher the
// value, the more she will be able to endure before dying. Starts at a value of 99 and expands by 100 points
// for every "Energy Tank" she collects in the game world.
maxHitpoints = 99;
hitpoints = maxHitpoints;

#endregion

#region Initializing unique variables

// Variables relating to player input. The first stores a snapshot of the inputs pressed for the current frame,
// the second stores the previous frame's inputs, and the final value stores a 1 or -1 to signify is Samus is
// moving to the right or left, respectively.
inputFlags		= 0;
prevInputFlags	= 0;
movement		= 0;

// Variables to represent each of Samus's animations based on the suit she currently has equipped. They start
// with the Power Suit by default, and then are overwritten by the Varia Suit followed by the Gravity Suit when
// each of those are collected by the player.
introSprite		= spr_power_stand0;		// Intro sprite (Facing forward)
standSpriteFw	= spr_power_stand1;		// Standing sprites
standSpriteUp	= spr_power_stand2;
walkSpriteFw	= spr_power_walk0;		// Walking sprites
walkSpriteFwExt = spr_power_walk1;
walkSpriteUp	= spr_power_walk2;
jumpSpriteFw	= spr_power_jump1;		// Jumping sprites
jumpSpriteUp	= spr_power_jump2;
jumpSpriteDown	= spr_power_jump3;
jumpSpriteSpin	= spr_power_jump0;
crouchSprite	= spr_power_crouch0;	// Crouching sprite
morphballSprite = spr_power_mball0;		// Morphball sprites
ballEnterSprite = spr_power_mball1;

// Collision masks for some of Samus's states and substates. They determine that area that will be used to
// handle collisions between her, the world, hazards, and other entities. Their heights and vertical positions
// may differ, but their widths are always the same at 10 pixels to avoid bugged collisions.
standingMask	= spr_power_stand1;
jumpingMask		= spr_power_jump1;
crouchingMask	= spr_power_crouch0;
morphballMask	= spr_power_mball0;

// Stores any energy that Samus has "in reserve" relative to her main pool of energy. The first value stores
// the amount she has access to and the second value stores the maximum amount she can have at any given time.
reserveHitpoints	= 0;
maxReserveHitpoints = 0;

// Stores how many energy tank pieces Samus is currently holding. Once this value reaches four, Samus is given
// an energy tank and the is reduced back to zero.
energyTankPieces = 0;

// Samus's aeion energy. The first value is how much she has access to for her various aion abilities, and the
// second stores the maximum amount of aeion energy Samus can have access to at any given time.
curAeion = 0;
maxAeion = 0;

// Samus's missile and power bomb reserves, respectively. The first values of each pair store how much ammo Samus
// has of either type of wepaon, and the second values determine the maximum amount of ammunition Samus can store
// for either one.
numMissiles		= 0;
maxMissiles		= 0;
numPowerBombs	= 0;
maxPowerBombs	= 0;

// 
jumpHspdFactor	= 1.0;
jumpSoundID		= NO_SOUND;

// 
curBeam			= WEAPON_POWER_BEAM;
curMissile		= WEAPON_REG_MISSILE;
curWeapon		= curBeam; // Makes current beam the active weapon by default.
tapFireRate		= 1.0;
holdFireRate	= 1.0;

// 
curShiftDist	= 0;
prevMaxHspd		= 0.0;
prevAnimSpeed	= 0.0;

// 
liquidData = {
	// 
	liquidID : noone,
	
	// 
	maxHspdPenalty	: 0.0,
	maxVspdPenalty	: 0.0,
	hAccelPenalty	: 0.0,
	vAccelPenalty	: 0.0,
	
	// 
	damage			: 0,
	damageInterval	: 0.0,
	damageTimer		: 0.0,
};

// 
armCannon	= instance_create_struct(obj_arm_cannon);
armCannonX	= 0;
armCannonY	= 0;

// Variables for the ghosting effect utilized by Samus during her somersault and phase shift abilities. It is
// a cyclical buffer of eight ghost effect object instances the will be enabled/disabled/overwritten when
// required as the effect is being executed.
ghostEffectIndex	= 0;
ghostEffectIDs		= array_create(PLYR_NUM_GHOST_EFFECTS, noone);
for (var i = 0; i < PLYR_NUM_GHOST_EFFECTS; i++)
	ghostEffectIDs[i] = instance_create_struct(obj_player_ghost_effect);

// Stores the instance ID for the bomb explosion that last collided with Samus. This is required in order to
// prevent that explosion from setting her vspd to -4.0 until it disappears instead of the intended logic of
// the vspd only being set during the very first frame of the collision occurring.
bombExplodeID = noone;

// Stores the instance ID for the warp object that Samus had collided with in order to reference it for the info
// it has regarding the room and position to send the game to.
warpID = noone;

// TIMER VARIABLES ////////////////////////////////////////////////////////////////////////////////////////////////////

// Substate Timers
standingTimer = 0.0;			// Counts time until Samus stands up from a crouch when left or right inputs held.
aimReturnTimer = 0.0;			// Tracks amount of time before Samus can return to aiming forward in various cases.
aimSwitchTimer = 0.0;			// Prevents Samus from aiming upward instantly after a crouch by waiting a small amount.

// Animation Timers
mBallTransformTimer	= 0.0;		// Tracks time that Samus's enter/exit morphball animation has been active.
jumpStartTimer = 0.0;			// Interval used to swap between the two-frame animation that occurs at the beginning of a jump.
flickerTimer = 0.0;				// Increments to a given value before flipping Samus from being invisible to seen.

// Aeion Timers
aeionCooldownTimer = 0.0;		// Tracks how much time has passed since the last Aeion ability was used; preventing another until the cooldown hits the needed value.
aeionFillTimer = 0.0;			// Increments until it hits a value of 1.0 or greater in order to increment current aeion energy by one unit.

// Arm Cannon Timers
fireRateTimer = 0.0;			// Tracks amount of time since the last projectile was fired. Another projectile can't be fired until this value reaches its required amount.
chargeTimer = 0.0;				// Prevents Samus from firing a charged beam from her cannon until the required value is surpassed.

// Morphball Timers
bombDropTimer = 0.0;			// Tracks the amount of time that has passed since Samus last deployed a standard bomb. When equal to 0.0, another bomb can be dropped.

// Ghost Effect Timer
effectTimer	= 0.0;				// Tracks time between ghost effects spawning during Samus's somersault and phase shift.

// Repeating Sound Timers
footstepTimer = 0.0;			// Determines amount of time since the last footstep sound was played to see if another one should play.
screwAtkTimer = 0.0;			// Keeps track of the position into the screw attack sound that is played during the ability's used so it can seamlessly loop. 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endregion

#region Utility function initialzations

/// @description Handles input processing for the player object by polling the active input device. Unique
/// to the gamepad is analog stick movement, which uses unique variables since they can't feasibly be stored 
/// in the "inputFlags" variable.
process_input = function(){
	if (hitstunTimer != -1.0){ // Ignore all player input during the initial hitstun.
		inputFlags = 0;
		return;
	}
	
	// Store the previous frame's input flags into "prevInputFlags" before clearing the "inputFlags" variable
	// to zero before input is polled again. Then, a check against gamepad inputs occurs if a controller is
	// in use by the player. Otherwise, keyboard inputs are checked instead.
	prevInputFlags	= inputFlags;
	inputFlags		= 0;
	if (GAMEPAD_IS_ACTIVE){
		
		return;
	}
	
	// --- Movement Input Checks --- //
	if (keyboard_check(KEYCODE_GAME_RIGHT))		{inputFlags |= PLYR_RIGHT;}
	if (keyboard_check(KEYCODE_GAME_LEFT))		{inputFlags |= PLYR_LEFT;}
	if (keyboard_check(KEYCODE_GAME_UP))		{inputFlags |= PLYR_UP;}
	if (keyboard_check(KEYCODE_GAME_DOWN))		{inputFlags |= PLYR_DOWN;}
	if (keyboard_check(KEYCODE_JUMP))			{inputFlags |= PLYR_JUMP;}
	// --- Arm Cannon/Bomb Use Input Check --- //
	if (keyboard_check(KEYCODE_USE_WEAPON))		{inputFlags |= PLYR_USE_WEAPON;}
	// --- Beam Switch/Shortcut Input Checks --- //
	if (keyboard_check(KEYCODE_SWAP_WEAPON))	{inputFlags |= PLYR_SWAP_WEAPON;}
	if (keyboard_check(KEYCODE_HOTKEY_ONE))		{inputFlags |= PLYR_POWBEAM;}
	if (keyboard_check(KEYCODE_HOTKEY_TWO))		{inputFlags |= PLYR_ICEBEAM;}
	if (keyboard_check(KEYCODE_HOTKEY_THREE))	{inputFlags |= PLYR_WAVBEAM;}
	if (keyboard_check(KEYCODE_HOTKEY_FOUR))	{inputFlags |= PLYR_PLSBEAM;}
	// --- Missile Shortcut Input Checks --- //
	if (keyboard_check(KEYCODE_HOTKEY_FIVE))	{inputFlags |= PLYR_REGMISSILE;}
	if (keyboard_check(KEYCODE_HOTKEY_SIX))		{inputFlags |= PLYR_ICEMISSILE;}
	if (keyboard_check(KEYCODE_HOTKEY_SEVEN))	{inputFlags |= PLYR_SHKMISSILE;}
	// --- Missile/Power Bomb Activate Input Check --- //
	if (keyboard_check(KEYCODE_ALT_WEAPON))		{inputFlags |= PLYR_ALT_WEAPON;}
	// --- Aeion Ability Input Checks --- //
	if (keyboard_check(KEYCODE_PHASE_SHIFT))	{inputFlags |= PLYR_PHASE_SHIFT;}
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
	movement = PLYR_RIGHT_HELD - PLYR_LEFT_HELD;
	if (movement != 0){ // Player is moving; apply acceleration in required direction.
		// Optionally snapping Samus's current velocity to zero if she changes directions without coming to
		// a complete stop beforehand.
		if (_snapToZero && ((movement == MOVE_DIR_LEFT && hspd > 0.0) || 
				(movement == MOVE_DIR_RIGHT && hspd < 0.0))){
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
		if (hspd > _maxHspd)		{hspd =  _maxHspd;}
		else if (hspd < -_maxHspd)	{hspd = -_maxHspd;}
		
		// Set Samus's flag for "moving" to let the rest of her code know she is currently moving.
		stateFlags |= PLYR_MOVING;
	} else if (_canDecelerate){ // Player is no longer being moved; decelerate her horizontal velocity to zero.
		var _deltaAccel = get_hor_accel() * _hAccelFactor * DELTA_TIME;
		hspd -= _deltaAccel * sign(hspd);
		if (hspd >= -_deltaAccel && hspd <= _deltaAccel){ // Set all hspd values to zero and disable any necessary flags.
			stateFlags	&= ~(PLYR_MOVING | PLYR_FIRING_CANNON);
			hspdFraction = 0.0;
			hspd		 = 0.0;
		}
	}
	
	// Applying a fix for Samus's horizontal velocity that can occur with this movement and collision system.
	// In short, it will check to see that there isn't an obstacle right in front of Samus. If there is one,
	// her hspd values are zeroed out and her flag for "moving" is set to false. If this wasn't done her
	// hspd value would constantly increase to 1 before zeroing out at the collision check so long as the
	// player was holding either the right or left movement inputs; making her run while against walls due
	// to that "moving" flag never being set to false despite any actual movement being obstructed.
	var _movement = x + movement;
	if (movement != 0 && DNTT_IS_GROUNDED && place_meeting(_movement, y, par_collider)){
		var _yOffset = 0;
		while(place_meeting(_movement, y - _yOffset, par_collider) && _yOffset < maxHspd) 
			_yOffset++;
		if (place_meeting(_movement, y - _yOffset, par_collider)){
			stateFlags	&= ~PLYR_MOVING;
			hspdFraction = 0.0;
			hspd		 = 0.0;
		}
	}
	// TODO -- Find way to avoid this redundant collision check
}

/// @description 
/// @param {Bool}	skipAnimTime	Optional skip over start up animation that plays after the player presses the jump button.
grounded_to_airborne = function(_skipAnimTime = true){
	if (!DNTT_IS_GROUNDED && !PLYR_IN_MORPHBALL){
		object_set_next_state(state_airborne);
		entity_set_sprite(jumpSpriteFw, jumpingMask);
		stateFlags	   &= ~PLYR_MOVING;
		aimReturnTimer	= 0.0;
		if (_skipAnimTime)  {jumpStartTimer = PLYR_FLIP_START_TIME;}
		else				{jumpStartTimer = 0.0;}
		return true; // Samus is no longer on the ground; return true to signify such.
	}
	
	// By default, this function will return false to signify no change in Samus's "Grounded" state occurring.
	return false;
}

/// @description Since this piece of code needs to be utilized for two seperate scenarios in the crouching
/// state, it's been outlined and placed into its own function to simplify the crouching state's code; 
/// improving code readability.
crouch_to_standing = function(){
	mask_index = standingMask; // Swap masks for accurate collision processing.
	if (!place_meeting(x, y, par_collider)){
		play_sound_effect(snd_aimcannon, 0, false, true, PLYR_AIMCANNON_VOLUME, 0.0, 0.8);
		object_set_next_state(state_default);
		entity_set_sprite(standSpriteFw, standingMask);
		stateFlags	   &= ~PLYR_CROUCHED;
		standingTimer	= 0.0;
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
		object_set_next_state(state_exit_morphball);
		entity_set_sprite(ballEnterSprite, morphballMask);
		bombDropTimer	= 0.0;
		bombExplodeID	= noone;
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
	var _isAiming		= PLYR_IS_AIMING;
	var _useHeld		= PLYR_USE_HELD;
	var _usePressed		= PLYR_USE_PRESSED;
	var _useReleased	= PLYR_USE_RELEASED;
	if ((_useHeld || _usePressed) && !_isAiming){
		if (PLYR_IN_SOMERSAULT || PLYR_IN_SCREWATK){
			stateFlags &= ~(PLYR_SOMERSAULT | PLYR_SCREWATK);
			hspd		= 0.0;
			reset_light_source();
			audio_stop_sound(jumpSoundID);
			jumpSoundID = NO_SOUND;
		}
		stateFlags	   |= PLYR_FIRING_CANNON;
		aimReturnTimer	= 0.0;
	}
	
	// Handling the charge beam logic, which is only factored in if the player doesn't have a missile equipped
	// and they have the optional charge beam item collected.
	var _isCharged = false;
	if (curWeapon == curBeam){
		if (_useHeld && event_get_flag(FLAG_CHARGE_BEAM)){
			chargeTimer += DELTA_TIME;
			if (chargeTimer >= PLYR_CHARGE_LOOP_TIME)
				chargeTimer = PLYR_CHARGE_LOOP_TIME;
		
			// Prevent any normal beam projectile from being created while the charge timer is increasing.
			if (chargeTimer >= min(tapFireRate, 5.0)){
				aimReturnTimer = 0.0;
				return;
			}
		}
		
		// Determine if the beam is fully charged relative to the timer's current value and if the player has
		// released the fire button. The timer for charge is reset on this button's release.
		_isCharged = (_useReleased && chargeTimer >= PLYR_CHARGE_TIME);
		if (_useReleased) {chargeTimer = 0.0;}
	}
	
	// Create local variables that store the conditions required for creating a projectile at the proper
	// intervals of time. It can handle either tapping the fire button or holding it (This can only be done
	// prior to acquiring the Charge Beam); basing the required time between shots based on them.
	var _holdingFire	= (_useHeld && !_isCharged && fireRateTimer == holdFireRate);
	var _tappingFire	= (_usePressed && fireRateTimer >= tapFireRate);
	var _chargeFire		= (_useReleased && _isCharged);
	if (_holdingFire || _tappingFire || _chargeFire){
		// Create a local variable that will store the value that will be copid into the projectile's substate
		// variable "stateFlags". It will flip the appropriate flag for the projectile's movement such that
		// it moves in the direction that the arm cannon is currently facing.
		var _flags		= (_isCharged) ? PROJ_CHRBEAM : 0; // Flip flag bit if the projectile was charged.
		var _aimingDown	= PLYR_IS_AIMING_DOWN;
		if (!PLYR_IS_AIMING_UP && !_aimingDown) {_flags |= PROJ_MOVE_RIGHT;}
		else if (_aimingDown)					{_flags |= PROJ_MOVE_DOWN;}
		else									{_flags |= PROJ_MOVE_UP;}
		
		// Create a copy of all the important substate bits for the arm cannon's projectile. These are then
		// used to determine the position to move the projectile to so it comes out of Samus's arm cannon.
		var _playerFlags = stateFlags & (PLYR_MOVING | PLYR_CROUCHED | PLYR_AIMING_UP | 
											PLYR_AIMING_DOWN | DNTT_GROUNDED);
		if (image_xscale == MOVE_DIR_RIGHT)	{_playerFlags |= PLYR_FACING_RIGHT;} // Flip bit for current facing direction.
		else								{_playerFlags |= PLYR_FACING_LEFT;}
		
		// Finally, create the projectile; passing in the local copy of the player's current substate flags
		// (As well as her current facing direction in the 0th or 1st bit, respectively) and the flags that
		// will be assigned to the projectile's own substate variable. Reset the firing timer and the aim
		// return timer, respectively.
		create_projectile(_playerFlags, _flags);
		fireRateTimer	= 0.0;
		aimReturnTimer	= 0.0;
	}
	
	// Resetting the fire rate timer whenever a projectile has been shot; preventing the player from firing 
	// another until this timer has reached its "hold" threshold (If the charge beam isn't unlocked yet).
	// Tapping the fire button will yield a much faster fire rate than this method.
	if (fireRateTimer < holdFireRate){
		fireRateTimer += DELTA_TIME;
		if (fireRateTimer >= holdFireRate) 
			fireRateTimer = holdFireRate;
	}
	
	// Tracking time until the "aimReturnTimer" surpasses the required value, which will then make Samus lower
	// her arm cannon and return to a normal running animation if she happened to be on the ground and moving
	// during her projectile firing.
	if (_isAiming && !_useHeld){
		aimReturnTimer += DELTA_TIME;
		if (aimReturnTimer >= PLYR_LOWER_CANNON_TIME){
			stateFlags	   &= ~PLYR_FIRING_CANNON;
			aimReturnTimer	= 0.0;
		}
	}
}

/// @description Creates the "ghosting" effect that is created by Samus during the use of various movements
/// or abilities (Ex. Phase Shift and Somersaulting). Since all the ghost effect instances are already in
/// memory, the "creation" actually just reactivates the next instance within the cyclical "buffer" or
/// overwrites what that instance was previously representing if it was still active.
/// @param {Real}	color		Hue to blend the ghost sprite with.
/// @param {Real}	alpha		Total opacity of the ghosting effect (Higher == longer last effect).
/// @param {Bool}	drawCannon	Determines whether or not the ghosting effect should render Samus's arm cannon or not.
create_ghosting_effect = function(_color, _alpha, _drawCannon){
	// Store all the variables from Samus that are required by the effect instance to copy exactly where she
	// is, what she is doing, AND if her separated arm cannon sprite is currently visible or not.
	var _x			= x;
	var _y			= y;
	var _sprite		= sprite_index;
	var _xScale		= image_xscale;
	var _image		= floor(imageIndex);
	var _armCannon	= armCannon;
	with(ghostEffectIDs[ghostEffectIndex]){
		visible		 = true;	// Set visiblity to "true" to enable effect's processing.
		x			 = _x;
		y			 = _y;
		sprite_index = _sprite;
		image_xscale = _xScale;
		image_blend	 = _color;
		imageIndex	 = _image;
		alpha		 = _alpha;
		
		// Skip accessing the arm cannon struct that exists within this effect object instance if it doesn't
		// need to be drawn for the given sprite. Otherwise, copy all required sprite flipping and position
		// offset data so it matches how Samus's normal sprite should look.
		if (!_drawCannon) {break;}
		drawArmCannon = _drawCannon;
		with(armCannon){
			var _xx = 0;
			var _yy = 0;
			with(_armCannon){
				_xx		= x;
				_yy		= y;
				_image	= imageIndex;
			}
			x			 = _xx;
			y			 = _yy;
			image_xscale = _xScale;
			imageIndex	 = _image;
		}
	}
	
	// Increment value stored by one so the next instance within the array is reset upon calling this function
	// again. The value is wrapped back around to 0 once it exceeds the limit of the array.
	ghostEffectIndex++;
	if (ghostEffectIndex == PLYR_NUM_GHOST_EFFECTS)
		ghostEffectIndex = 0;
}

/// @description Resets Samus's ambient light source to match the settings it had when it was being used to
/// represent the light coming from her helmet's visor. It will assume Samus is standing, and will place the
/// light at the offset that matches such a state.
reset_light_source = function(){
	var _visorColor	= HEX_LIGHT_GREEN;
	var _isAimingUp = PLYR_IS_AIMING_UP;
	with(lightComponent){
		radius		= LGHT_VISOR_RADIUS;
		baseRadius	= LGHT_VISOR_RADIUS;
		strength	= LGHT_VISOR_STRENGTH;
		color		= _visorColor;
		isActive	= !_isAimingUp;
	}
	lightOffsetX = LGHT_VISOR_X_GENERAL;
	lightOffsetY = LGHT_VISOR_Y_GENERAL;
}

/// @description Increases Samus's current energy reserves by the amount specified in the function argument. 
/// There is a limit of 1299 for available energy, so the amount will not increase if that value is reached.
/// @param {Real}	modifier	Value to add to the current energy capacity.
update_maximum_energy = function(_modifier){
	if (maxHitpoints == ENERGY_LIMIT || _modifier <= 0)
		return;
	hitpoints		= (hitpoints + _modifier > ENERGY_LIMIT)	? ENERGY_LIMIT : hitpoints + _modifier;
	maxHitpoints	= (maxHitpoints + _modifier > ENERGY_LIMIT) ? ENERGY_LIMIT : maxHitpoints + _modifier;
	with(GAME_HUD) // Update HUD's stored value for player's maximum energy capacity.
		pMaxEnergyTanks = floor(other.maxHitpoints * 0.01);
}

/// @description Increases Samus's current aeion energy by the amount specified in the function argument. 
/// There is a limit of 100 for available aeion, so the amount will not increase if that value is reached.
/// @param {Real}	modifier	Value to add to the maximum aeion capacity.
update_maximum_aeion = function(_modifier){
	if (maxAeion == AEION_LIMIT || _modifier <= 0)
		return;
	curAeion = (curAeion + _modifier > AEION_LIMIT) ? AEION_LIMIT : curAeion + _modifier;
	maxAeion = (maxAeion + _modifier > AEION_LIMIT) ? AEION_LIMIT : maxAeion + _modifier;
	with(GAME_HUD){ // Update HUD's stored value for player's max aeion capacity.
		pMaxAeion = other.maxAeion;
		if (!CAN_SHOW_AEION_GAUGE && pMaxAeion != 0) 
			stateFlags |= SHOW_AEION_GAUGE;
	}
}

/// @description Increases Samus's current missile ammunition capacity by the amount specified in the function
/// argument. There is a limit of 250 for the capacity, so the count will not increase if that value is reached.
/// @param {Real}	modifier	Value to add to the current missile ammunition capacity.
update_maximum_missiles = function(_modifier){
	if (maxMissiles == MISSILE_LIMIT || _modifier <= 0) 
		return;
	numMissiles = (numMissiles + _modifier > MISSILE_LIMIT) ? MISSILE_LIMIT : numMissiles + _modifier;
	maxMissiles = (maxMissiles + _modifier > MISSILE_LIMIT) ? MISSILE_LIMIT : maxMissiles + _modifier;
	with(GAME_HUD){ // Update HUD's stored value for player's max missile ammo count.
		pMaxMissiles = other.maxMissiles;
		if (!CAN_SHOW_MISSILES && event_get_flag(FLAG_MISSILES)) 
			stateFlags |= SHOW_MISSILES;
	}
}

/// @description Increases Samus's current power bomb supply by the amount specified in the function argument. 
/// There is a limit of 15 for power bombs, so the count will not increase if that value is reached.
/// @param {Real}	modifier	Value to add to the current power bomb supply.
update_maximum_power_bombs = function(_modifier){
	if (maxPowerBombs == POWER_BOMB_LIMIT || _modifier <= 0) 
		return;
	numPowerBombs = (numPowerBombs + _modifier > POWER_BOMB_LIMIT) ? POWER_BOMB_LIMIT : numPowerBombs + _modifier;
	maxPowerBombs = (maxPowerBombs + _modifier > POWER_BOMB_LIMIT) ? POWER_BOMB_LIMIT : maxPowerBombs + _modifier;
	with(GAME_HUD){ // Update HUD's stored value for player's max power bomb count.
		pMaxPowerBombs = other.maxPowerBombs;
		if (!CAN_SHOW_PBOMBS && event_get_flag(FLAG_POWER_BOMBS))
			stateFlags |= SHOW_PBOMBS;
	}
}

#endregion

#region Aeion ability activation functions

/// @description 
activate_energy_shield = function(){
	
}

/// @description Activates the Phase Shift ability if Samus has access to it. Doing so will transition Samus
/// into her state for the ability, which prevents all inputs until Samus has collided with a wall or has 
/// reached her phase shift's total distance.
/// @param {Real}	movement
activate_phase_shift = function(_movement){
	if ((curAeion < PLYR_PSHIFT_COST || aeionCooldownTimer > 0.0) && !event_get_flag(FLAG_PHASE_SHIFT)) 
		return false;
	curAeion -= PLYR_PSHIFT_COST; // Remove the cost of the ability's use from Samus's current aeion amount.
	
	if (PLYR_IN_SOMERSAULT){ // Exit Samus from her somersault should she be in one upon the phase shift's activation.
		entity_set_sprite(jumpSpriteFw, -1);
	} else{ // Use the first frame of animation for the walking sprite that isn't aiming Samus's arm cannon when on the floor.
		if (sprite_index == standSpriteFw || sprite_index == standSpriteUp) 
			entity_set_sprite(walkSpriteFw, standingMask);
		imageIndex = 0;
	}
	prevAnimSpeed	= animSpeed; // Store animation speed before it's zeroed out.
	animSpeed		= 0.0;
	
	// Turn Samus's ambient visor light into a bright blue flash for the duration of the ability.
	lightComponent.set_properties(LGHT_PSHIFT_RADIUS, HEX_LIGHT_BLUE, LGHT_PSHIFT_STRENGTH);
	lightOffsetX = 0;
	lightOffsetY = -20;
	
	// Apply the correct state and flags to Samus to signify to other objects she's executing her phase shift.
	// Change required variables to values they need to be during the ability's effect.
	object_set_next_state(state_phase_shift);
	stateFlags		   &= ~ENTT_DRAW_SELF | PLYR_SOMERSAULT | PLYR_SCREWATK;
	stateFlags		   |= PLYR_PHASE_SHIFT;
	effectTimer			= PLYR_SHIFT_INTERVAL;
	aeionCooldownTimer	= PLYR_PSHIFT_COOLDOWN;
	vspd				= 0.0; // All vertical movement is cancelled out by the ability.
	
	// Store the previous maximum hspd value and it will be overwritten to match Samus's speed during the
	// phase shift. Without this, she would get stuck on slope since it wiould assume her default maximum hspd
	// of 2.2 instead of the 12.0 it should be.
	prevMaxHspd = maxHspd;
	maxHspd	= PLYR_PSHIFT_SPEED;
	if (_movement == 0) // No movement input will result in Samus shifting herself backwards.
		hspd = (PLYR_PSHIFT_SPEED * -image_xscale);
	else // Move in the direction that the player is currently holding if detected.
		hspd = (PLYR_PSHIFT_SPEED * _movement);
	
	// Clear fractional values that were stored prior to the phase shift's activation are cleared to avoid
	// potential issues with anything stored here during the phase shift's movement logic.
	hspdFraction = 0.0;
	vspdFraction = 0.0;
	
	// Aeion ability activated; return true to let the state that called this function know.
	return true;
}

/// @description 
activate_scan_pulse = function(){
	
}

#endregion

#region Projectile/bomb spawning functions

/// @description 
/// @param {Real}	playerFlags 
/// @param {Real}	flags
create_projectile = function(_playerFlags, _flags){
	var _splitBeam = event_get_flag(FLAG_BEAM_SPLITTER);
	switch(curWeapon){
		default: // By default the Power Beam will always be fired.
		case WEAPON_POWER_BEAM:
			if (_splitBeam)	{create_power_beam_split(x, y, _playerFlags, _flags);}
			else			{create_power_beam(x, y, _playerFlags, _flags);}
			tapFireRate		= 5;
			holdFireRate	= 20;
			break;
		case WEAPON_ICE_BEAM:
			if (_splitBeam)	{/*create_ice_beam_split(x, y, _playerFlags, _charged);*/}
			else			{create_ice_beam(x, y, _playerFlags, _flags);}
			tapFireRate		= 36;
			holdFireRate	= 46;
			break;
		case WEAPON_WAVE_BEAM:
			show_debug_message("WAVE BEAM");
			tapFireRate		= 18;
			holdFireRate	= 28;
			break;
		case WEAPON_PLASMA_BEAM:
			show_debug_message("PLASMA BEAM");
			tapFireRate		= 14;
			holdFireRate	= 26;
			break;
		case WEAPON_REG_MISSILE:
			create_missile(x, y, _playerFlags, _flags);
			tapFireRate		= 24;
			holdFireRate	= 38;
			break;
		case WEAPON_ICE_MISSILE:
			show_debug_message("ICE MISSILE");
			tapFireRate		= 40;
			holdFireRate	= 60;
			break;
		case WEAPON_SHOCK_MISSILE:
			show_debug_message("SHOCK MISSILE");
			tapFireRate		= 32;
			holdFireRate	= 46;
			break;
	}
}

/// POWER BEAM ///////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Creates the projectile for Samus's standard power beam, which is just a single, fast-moving
/// projectile that can be fired in four unique directions: up, down, left, and right.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	playerFlags		
/// @param {Real}	flags			
create_power_beam = function(_x, _y, _playerFlags, _flags){
	var _projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile) {initialize(state_default, _x, _y, _playerFlags, _flags);}
}

/// @description Creates the projectile for the power beam influenced by the Beam Splitter powerup. Instead
/// of a single projectile, the power beam will now create three beams that will quickly split away from each
/// other before all moving parallel to each other; similar to how the Spazer Beam looked in Metroid II.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	playerFlags		
/// @param {Real}	flags			
create_power_beam_split = function(_x, _y, _playerFlags, _flags){
	// Two lines below are unchanged from the standard power beam's creation function; making this instance
	// the middle of the three that are created for the beam splitter's variation.
	var _projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile) {initialize(state_default, _x, _y, _playerFlags, _flags);}
	
	// Creating the "upper" power beam, which is another way to describe that it will be the one moving in the
	// negative direction of whatever axis is perpendicular to its moving axis.
	_projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile){
		stateFlags |= (1 << UPPER_POWER_BEAM); // Must be done before initialization.
		initialize(state_beam_splitter, _x, _y, _playerFlags, _flags);
	}
	
	// Creating the "lower" power beam, which moves toward the positive direction of whatever axis is perpendicular
	// to the one it is moving toward by default. (The "lower" of the three when facing right or left).
	_projectile = instance_create_object(0, 0, obj_power_beam);
	with(_projectile){
		stateFlags |= (1 << LOWER_POWER_BEAM); // Must be done before initialization.
		initialize(state_beam_splitter, _x, _y, _playerFlags, _flags);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// ICE BEAM /////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Creates the projectile for Samus's Ice Beam, which functions nearly identically to her Power
/// Beam with a single difference: the ability to freeze weaker enemies that it hits to use them as platforms.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	playerFlags		
/// @param {Real}	flags			
create_ice_beam = function(_x, _y, _playerFlags, _flags){
	var _projectile = instance_create_object(0, 0, obj_ice_beam);
	with(_projectile) {initialize(state_default, _x, _y, _playerFlags, _flags);}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// MISSILES (STANDARD, ICE, SHOCK) //////////////////////////////////////////////////////////////////////////////

/// @description Creates the standard missile projectile, which deals heavy damage and can destroy missile
/// blocks. Once upgraded to the "Super Missile" it will move faster, deal even more damage, and also shake
/// the screen when it collides with anything.
/// @param {Real}	x				Samus's current horizontal position within the room.
/// @param {Real}	y				Samus's current vertical position within the room.
/// @param {Real}	playerFlags		
/// @param {Real}	flags			
create_missile = function(_x, _y, _playerFlags, _flags){
	if (numMissiles == 0) {return;}
	
	// 
	var _hspd		= hspd;
	var _vspd		= vspd;
	var _signsMatch = (sign(_hspd) == sign(image_xscale));
	var _projectile = instance_create_object(0, 0, obj_missile);
	with(_projectile){
		initialize(state_default, _x, _y, _playerFlags, _flags);
		// Preserve the player's velocity for whatever direction the missile is heading toward to prevent
		// the missile from moving too slow relative to the player's movement.
		if (PROJ_MOVING_HORIZONTAL){
			if (_signsMatch) {hspd = _hspd;}
			else			 {hspd = 0.0;} // Don't apply player's hspd if facing direction doesn't match horizontal movement direction.
		} else if (_vspd >= 0 && PROJ_MOVING_DOWN){
			vspd	= _vspd;
			vAccel *= 2.0; // Doubles acceleration to prevent Samus falling faster than the missile accelerates.
		}
	}
	numMissiles--; // Subtracts one missile from the current ammo reserve.
	
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
	if (PLYR_ALT_WEAPON_HELD && event_get_flag(FLAG_MISSILES)){
		// Swap to the next missile depending on which of the input(s) has been pressed by the player. The
		// priority of missiles is: standard, ice, and shock, whenever multiple of these inputs are pressed
		// at once occurs.
		if (PLYR_REGMISSILE_PRESSED)		{curMissile = WEAPON_REG_MISSILE;}
		else if (PLYR_ICEMISSILE_PRESSED)	{curMissile = WEAPON_ICE_MISSILE;}
		else if (PLYR_SHKMISSILE_PRESSED)	{curMissile = WEAPON_SHOCK_MISSILE;}
		
		// Update the variables for the fire rate timers and charging timers to reflect this change in weapon.
		if (curWeapon != curMissile){
			curWeapon		= curMissile;
			tapFireRate		= PLYR_MISSILE_SWAP_TIME;
			holdFireRate	= PLYR_MISSILE_SWAP_TIME;
			fireRateTimer	= 0.0;
			chargeTimer		= 0.0;
		}
		return;
	}
	
	// Much like for missiles, the beam will be switched to whichever one has its hotkey pressed relative to
	// that beam hotkey's priority if multiple happn to be pressed at the same time by the player. The priority
	// order is as follows: power, ice, wave, and plasma, respectively.
	if (PLYR_POWBEAM_PRESSED)		{curBeam = PLYR_POWBEAM;}
	else if (PLYR_ICEBEAM_PRESSED)	{curBeam = PLYR_ICEBEAM;}
	else if (PLYR_WAVBEAM_PRESSED)	{curBeam = PLYR_WAVBEAM;}
	else if (PLYR_PLSBEAM_PRESSED)	{curBeam = PLYR_PLSBEAM;}
	
	// Update the variables for the fire rate timers and charging timers to reflect this change in weapon.
	if (curWeapon != curBeam){
		curWeapon		= curBeam;
		tapFireRate		= PLYR_BEAM_SWAP_TIME;
		holdFireRate	= PLYR_BEAM_SWAP_TIME;
		fireRateTimer	= 0.0;
		chargeTimer		= 0.0;
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
	entity_set_sprite(introSprite, spr_empty_mask);
	object_add_light_component(x, y, 0, 
		LGHT_VISOR_Y_GENERAL, LGHT_VISOR_RADIUS, HEX_LIGHT_GREEN, LGHT_VISOR_STRENGTH, true);
	stateFlags |= ENTT_DRAW_SELF | ENTT_LOOP_ANIM | ENTT_INVINCIBLE;
	
	// FOR TESTING
	var _hitpoints = hitpoints;
	with(GAME_HUD) {pCurEnergy = _hitpoints;}
	game_set_state(GSTATE_NORMAL, true);
}

/// @description A modification to the entity's hitpoint manipulation function; allowing the entity to be
/// given hitpoints or have them taken away depending on the modifier value. It will autiomatically handle
/// utilization of the reserve hitpoints should the player reach zero hitpoints while having some available
/// in their reserve. Otherwise, the player will be flagged as "destroyed" which will signal to the game
/// that the game over screen should be shown.
/// @param {Real}	modifier	The value that will be subtracted (Argument is negative) or added (Argument is positive) to the entity's hitpoints.
update_hitpoints = function(_modifier){
	if (_modifier == 0) {return;}
	hitpoints += floor(_modifier); // Value is floored so it's always an integer.
	if (hitpoints > maxHitpoints){ // Prevent the player's hitpoints from exceeding the maximum.
		hitpoints = maxHitpoints;
	} else if (hitpoints <= 0){
		hitpoints = 0;
		// Check for reserve hitpoints. If the player has an amount to utilize, it will be added to their
		// hitpoints and whatever amount was put into there is remove from the reserve; reviving the player.
		if (reserveHitpoints > 0){
			update_hitpoints(reserveHitpoints);
			reserveHitpoints -= hitpoints;
			return; // Don't kill off the player.
		}
		// If the player has no reserve hitpoints left to utilize, they will have their state removes, and
		// no longer show up on screen. The destroyed flag is flipped, but since the player object is set
		// to "invincible" they won't be deleted from the game.
		curState	= NO_STATE;
		stateFlags &= ~(ENTT_DRAW_SELF | ENTT_HIT_STUNNED);
		stateFlags |= ENTT_DESTROYED;
		
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
	if (_modifier == 0.0) {return;}
	curAeion += _modifier;
	if (curAeion > maxAeion)	{curAeion = maxAeion;}
	else if (curAeion < 0.0)	{curAeion = 0.0;}
}

#endregion

#region Additional collision functions

/// @description Processing collision with a collider that interacts with Samus uniquely. It will be destroyed
/// by Samus is she walks across it, but won't be destroyed or manipulated otherwise. This means any other
/// entity can walk along this floor and have it react like a standard collider would.
fallthrough_floor_collision = function(){
	var _floorCollapsed = false;
	with(instance_place(x, y + 1, obj_destructible_weight)){
		if (!ENTT_IS_DESTROYED){
			destructible_destroy_self();
			_floorCollapsed = true;
		}
	}
	
	if (_floorCollapsed && !place_meeting(x, y + 1, par_collider)){
		grounded_to_airborne(false);
		hspd = 0.0;
		vspd = 0.0;
	}
}

/// @description Handles collisions between Samus and destructible blocks. These blocks must be weak to the
/// Screw Attack in order to be processed by this function, and will be destroyed if they are close enough to
/// Samus while she is executing the Screw Attack while jumping.
destructible_screw_attack_collision = function(){
	var _x = x; // X value is already in the center of Samus's sprite on screen; y must be calculated.
	var _y = bbox_bottom - ((bbox_bottom - bbox_top) >> 1);	
	with(par_destructible){
		if (!ENTT_IS_ON_SCREEN || ENTT_IS_DESTROYED || (object_index != obj_destructible_all 
				&& object_index != obj_destructible_screw_attack))
			continue;
			
		if (point_distance(x + 8, 0, _x, 0) <= DEST_SCREWATK_XBOUNDS &&
				point_distance(0, y + 8, 0, _y) <= DEST_SCREWATK_YBOUNDS)
			destructible_destroy_self();
	}
}

/// @description Checks for collision between the player and a collectible. It does so by temporarily enabling
/// the collider for the item (If one exists) and checking those collision bounds with the player's. If they
/// are intersecting, the collectible will be given to the player.
player_collectible_collision = function(){
	var _playerID = id;
	with(instance_nearest(x, y, par_collectible)){
		mask_index = -1; // Temporarily enable the collectible's collision box to check again the player's.
		if (!DEST_IS_HIDDEN && place_meeting(x, y, _playerID)){
			var _instanceID	= id;
			var _itemID		= itemID;
			var _sound		= audio_play_sound(fanfare, 0, false);
			var _menu		= instance_create_menu_struct(obj_item_collection_screen);
			with(_menu){
				menu_set_next_state(state_animation_alpha, [1.0, 0.1, state_default]);
				set_item_data(_itemID);
				hudAlphaTarget		 = GAME_HUD.alphaTarget;
				itemInstance		 = _instanceID;
				soundID				 = _sound;
				GAME_HUD.alphaTarget = 0.0; // Fade HUD out until item is "collected" by the player.
			}
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
	if (PLYR_IS_SUBMERGED){
		// Count down the liquid's damage interval and dish out its damage if it should damage the player.
		// Otherwise, ignore this code and just perfrom the collision check below.
		var _id = noone;
		var _damage = 0;
		with(liquidData){
			_id = liquidID;
			if (damage == 0) {break;}
			
			damageTimer += DELTA_TIME;
			if (damageTimer >= damageInterval){
				damageTimer -= damageInterval;
				_damage		 = -damage; // Damage must be negative to take away energy from the player.
			}
		}
		
		// Only bother flashing the player's sprite and dealing with current hitpoints if the liquid in
		// question can cause damage to them. Otherwise, this small chunk of code is skipped.
		if (_damage != 0) {update_hitpoints(_damage);}
		
		// Check if the player is no longer colliding with the liquid they initially entered OR that the
		// value for "_id" wasn't updated past its initial value for some reason. If either is the case,
		// the player will be considered to have emerged from the liquid and will no longer be hindered
		// by it if they didn't have the gravity suit at the time.
		if (_id == noone || !place_meeting(x, y, _id)){
			// Reverse the impact on the player's horizontal and vertical speed/acceleration that the
			// liquid had, but only if they don't have access to the gravity suit currently.
			if (!event_get_flag(FLAG_GRAVITY_SUIT)){
				maxHspdFactor	+= liquidData.maxHspdPenalty;
				maxVspdFactor	+= liquidData.maxVspdPenalty;
				hAccelFactor	+= liquidData.hAccelPenalty;
				vAccelFactor	+= liquidData.vAccelPenalty;
			}
			
			// Clear all of the data from the liquid data struct and reverse the bit that tells the game
			// Samus is submerged in a liquid.
			with(liquidData){
				liquidID		= noone;
				maxHspdPenalty	= 0.0;
				maxVspdPenalty	= 0.0;
				hAccelPenalty	= 0.0;
				vAccelPenalty	= 0.0;
				damage			= 0;
				damageInterval	= 0.0;
				damageTimer		= 0.0;
			}
			stateFlags |= (1 << DRAW_SPRITE);
			stateFlags &= ~(PLYR_SUBMERGED | PLYR_SPRITE_FLICKER);
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
		var _damage = _id.damage;
		with(liquidData){
			liquidID		= _id;
			maxHspdPenalty	= _id.maxHspdPenalty;
			maxVspdPenalty	= _id.maxVspdPenalty;
			hAccelPenalty	= _id.hAccelPenalty;
			vAccelPenalty	= _id.vAccelPenalty;
			damage			= _damage;
			damageInterval	= _id.damageInterval;
		}
		
		// 
		if (_damage != 0 && !ENTT_IS_HIT_STUNNED){
			stateFlags	   |= PLYR_SPRITE_FLICKER;
			flickerTimer	= PLYR_HIT_INTERVAL;
		}
		
		// Only slow the player down in the liquid if they don't have access to the gravity suit. If they
		// do have the gravity suit, the only effect the liquid will have is initial submersion that slows
		// the player down upon impact with it.
		if (!event_get_flag(FLAG_GRAVITY_SUIT)){
			maxHspdFactor	-= liquidData.maxHspdPenalty;
			maxVspdFactor	-= liquidData.maxVspdPenalty;
			hAccelFactor	-= liquidData.hAccelPenalty;
			vAccelFactor	-= liquidData.vAccelPenalty;
		}
		
		// Regardless of having access to the gravity suit, the player will still impact the water and find
		// themselves submerged, so the relevant flag for that is flipped, and the player's hspd and vspd
		// are drastically reduced to really sell the impact with the liquid.
		stateFlags	|= PLYR_SUBMERGED;
		hspd		*= 0.35;
		vspd		*= 0.15;
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
		
		// Determine the position to place the surface that contains a snapshot of Samus at. This snapshot
		// is just the last frame of animation she was in, and her arm cannon if it was being shown for said
		// animation. The position needs the camera's value remove from it since it is drawn on the GUI layer.
		var _camera = CAMERA.camera;
		var _x		= x - sprite_get_xoffset(sprite_index) - camera_get_view_x(_camera);
		var _y		= y - sprite_get_yoffset(sprite_index) - camera_get_view_y(_camera);
		with(SCREEN_FADE){
			playerX = _x - SURFACE_OFFSET_X;
			playerY = _y - SURFACE_OFFSET_Y;
		}
	}
}

/// @descripiton Checks for collision with an enemy so long as Samus isn't in her hitstun/recovery state. If
/// she is, the function will perform no collision check. If an enemy was collided with and Samus wasn't in
/// that hitstun/recovery state, she'll be damaged and sent into said state.
player_enemy_collision = function(){
	if (ENTT_IS_HIT_STUNNED)
		return;
	
	var _enemy = instance_place(x, y, par_enemy);
	if (_enemy != noone){
		var _inJumpAttack	= PLYR_IN_SCREWATK;
		var _curAilment		= AIL_NONE;
		var _damage			= 0;
		var _stunDuration	= 0.0;
		with(_enemy){
			// When utilizing her Screw Attack, Samus will be immune to all damage that could be inflicted
			// by an enemy during collision. On top of that, the enemy will instantly be killed if she hits
			// them and they aren't immune to the Screw Attack.
			if (_inJumpAttack){
				if (weaknessFlags & ENMY_SCREWATK_WEAK){
					stateFlags |= ENMY_DROP_ITEM;
					instance_destroy_object(id);
				}
				return;
			}
			
			// Copy information about enemy damage/stun duration data, as well as its current ailment so Samus
			// can use that data to determine if she should be considered "hit" or not.
			_damage			= damage;
			_stunDuration	= stunDuration;
			_curAilment		= curAilment;
		}

		// A frozen enemy OR one that doesn't deal any damage will also prevent the hitstun function from
		// being called; negating any hitstun or damage they may have inflicted otherwise.
		if (_curAilment == AIL_FROZEN || _damage == 0)
			return;
		entity_apply_hitstun(_stunDuration, _damage);
	}
}

/// @description Processes collisions between the player and an item drop, which includes energy restoration,
/// ammunition, and aeion energy drops. All of these objects can be dropped by enemies upon death.
player_item_drop_collision = function(){
	with(instance_nearest(x, y, par_item_drop)){
		mask_index = -1; // Temporarily enable the collision mask for the item drop.
		if (place_meeting(x, y, PLAYER)) {item_drop_collect_self();}
		mask_index = spr_empty_mask;
	}
}

#endregion

#region Player-specific hit stun function and state

// Stores the parent object's function for applying a hitstun effect onto an entity so it can be called in
// this function definition that would overwrite the reference to the original otherwise.
__entity_apply_hitstun = entity_apply_hitstun;
/// @description Samus's hitstun function, which implements the default entity function on top of the unique
/// code it requires regarding Samus's state and various variabnles.
/// @param {Real}	duration	The time in "frames" (60 units = 1 real-world second) to lock Samus's movement.
/// @param {Real}	damage		Total amount of damage to apply to Samus's current energy.
entity_apply_hitstun = function(_duration, _damage = 0){
	__entity_apply_hitstun(_duration, _damage);
	play_sound_effect(snd_damaged, 0, false, true, 0.5, 0.0, random_range(0.95, 1.05));
	if (!PLYR_IN_MORPHBALL){ // Make Samus airborne if she isn't in her morphball at the time of the hitstun.
		object_set_next_state(state_airborne);
		
		// During a somersault, a sound will be looping. This sound must be stopped upon incurring a hit by
		// an enemy, damaging, liquid, or environmental hazard since Samus gets forced out of her somersault.
		if (jumpSoundID != NO_SOUND){
			audio_stop_sound(jumpSoundID);
			jumpSoundID = NO_SOUND;
		}
		
		// Make sure the light moves itself to where the visor is since Samus's somersault is interrupted by
		// sustaining damage from an enemy or enemy projectile. Any animation timers are also skipped over.
		// Note that the light source is also reset if she was previously crouching as well.
		if (PLYR_IS_CROUCHED || PLYR_IN_SOMERSAULT || PLYR_IN_SCREWATK)
			reset_light_source();
		jumpStartTimer = PLYR_FLIP_START_TIME;
		aimReturnTimer = 0.0;
		
		// After animation times and visor light positions have been dealt with, Samus will have certain states
		// turned off, while also having a flag for "beam visibility" set to true so the arm cannon will render.
		stateFlags &= ~(PLYR_CROUCHED | PLYR_SCREWATK | PLYR_SOMERSAULT);
		stateFlags |= PLYR_BEAM_VISIBLE;
	}

	// Regardless of if in her morhpball mode or not, Samus will always be set to move backwards horizontally
	// and upward; resulting in an up-right or up-left trajectory depending on the direction she was facing
	// at the time of the attack.
	stateFlags	   &= ~DNTT_GROUNDED;
	stateFlags	   |= PLYR_SPRITE_FLICKER;
	flickerTimer	= PLYR_HIT_INTERVAL;
	hspd			= get_max_hspd() * 0.5 * -image_xscale;
	vspd			= -2.75;
}

#endregion

#region State function initializations

/// @description Samus's introduction state. From here, all the player will be able to do is press either the 
/// right or left inputs on their in-use input device in order to activate Samus; sending them to her default
/// state after the previous condition is met.
state_intro = function(){
	process_input();
	var _movement = PLYR_RIGHT_HELD - PLYR_LEFT_HELD;
	if (_movement != 0/* && !audio_is_playing(mus_samus_intro1)*/){
		audio_group_unload(samus_fanfares);		// Unload the songs from memory as they're no longer required.
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
	var _warpID		= warpID;
	var _camera		= CAMERA.camera;
	var _targetX	= x - sprite_get_xoffset(sprite_index) - camera_get_view_x(_camera) - SURFACE_OFFSET_X;
	var _targetY	= y - sprite_get_yoffset(sprite_index) - camera_get_view_y(_camera) - SURFACE_OFFSET_Y;
	with(SCREEN_FADE){
		if (alpha == 1.0 && alphaTarget == 1.0){
			// Handle position and room swapping code right before any transition effect code is executed;
			// preventing said code from completely before it even technically began.
			with(_warpID){
				// Prevents crashing and warping if the room provided doesn't exist.
				if (targetRoom == ROOM_INDEX_INVALID){
					instance_destroy_object(_warpID);
					other.alphaTarget	= 0.0;
					PLAYER.warpID		= noone;
					return;
				}
				
				// Move the player into position, clear out the reference to the warp that is executing
				// the current room warp, and load in the required room. Update the position of the arm
				// cannon as well to compensate for Samus's new position.
				var _doorAngle	= image_angle;
				var _bottom		= bbox_bottom;
				var _x			= targetX;
				var _y			= targetY;
				with(PLAYER){
					var _prevY	= y;
					x			= _x;
					y			= _y;
					// Properly offset Samus relative to how far she is off the ground relative to the
					// target y of the warp IF the door is a horizontal doorway while she's jumping.
					if ((_doorAngle == DIRECTION_EAST || _doorAngle == DIRECTION_WEST) && !DNTT_IS_GROUNDED)
						y = _y - (_bottom - _prevY);
					warpID = noone;
					
					// Since Samus is in her warping state, the previous state will be used to determine
					// where her arm cannon ends up relative to her position. Otherwise, its position will
					// not change between rooms alongside her.
					var _state = curState;
					curState = lastState;
					armCannon.end_step();
					curState = _state;
				}
				with(DEBUGGER) {lastRoom = room;}
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
			if (_closeScreenFade) {alphaTarget = 0.0;}
		} else if (alpha == 0.0 && alphaTarget == 0.0){
			with(other){ // Return Samus to her previous state unpon completion of the screen fade; returning her animation speed to normal as well.
				object_set_next_state(lastState);
				stateFlags &= ~ENTT_PAUSE_ANIM;
				warpID		= noone;
			}
		}
	}
}

/// @description Samus's default or "grounded, but standing" state. She can find herself in this state whenever
/// she is on the ground, but not in her morphball form OR crouching; aiming up doesn't affect anything either
/// than the sprite drawn for Samus while she is standing or walking. From here, she can enter her airborne
/// state whenever there is no longer a viable floor beneath her, and she can also enter into her crouching
/// state if the player presses the input they've bound to her "down" action.
state_default = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Call Samus's gravity function. Then, call the check to see if Samus should transition from grounded to
	// airborne. This function will return true when she is no longer grounded to signify the substate change.
	apply_gravity(PLYR_MAX_FALL_SPEED);
	if (grounded_to_airborne()) 
		return;
	
	// Another method of activating Samus's airborune state, but this is done by pressing the input set for
	// jumping. After that, Samus will have her vertical velocity set to whatever her jump height is (Stored
	// as her "maxVspd") and she will either enter a standard jump (Horizontal speed lower than 1) or a
	// somersault jump (Moving fast enough and not firing from Samus's arm cannon).
	if (PLYR_JUMP_PRESSED && !place_meeting(x, y - 1, par_collider)){
		object_set_next_state(state_airborne);
		play_sound_effect(snd_jumpstart, 0, false, true, PLYR_JUMPSTART_VOLUME);
		if (abs(hspd) >= 1.0 && !PLYR_IS_AIMING){
			if (event_get_flag(FLAG_SCREW_ATTACK)) // Toggle screw attack bit if ability has been unlocked.
				stateFlags |= PLYR_SCREWATK;
			stateFlags |= PLYR_SOMERSAULT;
			effectTimer	= PLYR_JUMP_INTERVAL;
		}
		stateFlags	   &= ~(DNTT_GROUNDED | PLYR_MOVING);
		vspd			= get_max_vspd();
		return; // State changed; don't process movement/animation within this function.
	}
	
	// Handling horizontal movement for both directions.
	var _hspdFactor = place_meeting(x + sign(movement), y, obj_collider_slope) ? 0.7 : 1.0;
	process_horizontal_movement(_hspdFactor, 1.0, true, true);
	
	// Entering Samus's crouching state, which lowers her down; shrinking her hitbox a bit vertically and 
	// moving her beam low enough to hit smaller targets. It's accessed by simply pressing the down input.
	if (PLYR_DOWN_PRESSED){
		object_set_next_state(state_crouching);
		entity_set_sprite(crouchSprite, crouchingMask);
		stateFlags	   &= ~(PLYR_AIMING_UP | PLYR_MOVING);
		stateFlags	   |= PLYR_CROUCHED;
		aimReturnTimer	= 0.0;
		hspd			= 0.0;
		hspdFraction	= 0.0;
		lightOffsetX	= LGHT_VISOR_X_CROUCH;
		lightOffsetY	= LGHT_VISOR_Y_CROUCH;
		return; // State changed; don't bother continuing with this state function.
	}
	
	// The aiming logic for Samus's default state, which only allows her to aim upward and forward; the latter
	// being the default aiming direction for her when aiming inputs (Up/down, respectively) aren't pressed.
	if (PLYR_UP_PRESSED){
		play_sound_effect(snd_aimcannon, 0, false, true, PLYR_AIMCANNON_VOLUME);
		stateFlags &= ~(PLYR_FIRING_CANNON | PLYR_AIMING_DOWN);
		stateFlags |=  PLYR_AIMING_UP;
		lightComponent.isActive = false;
	} else if (PLYR_UP_RELEASED){
		stateFlags &= ~PLYR_AIMING_UP;
		lightComponent.isActive = true;
	}
	
	// Another way of aiming Samus up that can only happen when she very recently exited her crouching state.
	// In short, it checks if the player is holding down the up input, which handles both exiting crouch AND
	// aiming up in order to prevent Samus instantly snapping to her upward aiming substate. This creates a 
	// very short buffer for her to aim forward before snapping upward (As long as the up key is held for the
	// required duration of this "aim switch buffer").
	if (!PLYR_IS_AIMING_UP && PLYR_UP_HELD){
		aimSwitchTimer += DELTA_TIME;
		if (aimSwitchTimer >= PLYR_AIM_BUFFER_TIME){
			play_sound_effect(snd_aimcannon, 0, false, true, PLYR_AIMCANNON_VOLUME);
			stateFlags			   &= ~(PLYR_FIRING_CANNON | PLYR_AIMING_DOWN);
			stateFlags			   |=  PLYR_AIMING_UP;
			aimSwitchTimer			= 0.0;
			lightComponent.isActive = false;
		}
	} else{
		aimSwitchTimer = 0.0;
	}
	
	// Activating the Phase Shift ability, which instantly exists the current state if the function returned
	// true. Otherwise, the ability cannot be activated and won't cause the current state to prematurely end.
	if (PLYR_PSHIFT_PRESSED && activate_phase_shift(movement)) 
		return;
		
	// Apply the correct horizontal light offset for the visor based on what direction Samus is currently
	// facing (This is determines by a 1 (Right) or -1 (Left) within "image_xscale".
	lightOffsetX = LGHT_VISOR_X_GENERAL;
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();

	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_item_drop_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	player_enemy_collision();
	player_warp_collision();
	
	// Setting a walking sprite to use if Samus is moving (Determined by the value of the bit flag "IS_WALKING"
	// at the end of the frame). She can have three possible animations for this substate: walking normally, 
	// with her beam aiming forward, or with her beam aiming upward.
	var _substate = stateFlags & (PLYR_FIRING_CANNON | PLYR_AIMING_UP);
	if (PLYR_IS_MOVING){
		var _animSpeed = abs(hspd) / maxHspd;
		switch(_substate){
			default:					entity_set_sprite(walkSpriteFw,	standingMask, _animSpeed);		break;
			case PLYR_FIRING_CANNON:	entity_set_sprite(walkSpriteFwExt, standingMask, _animSpeed);	break;
			case PLYR_AIMING_UP:		entity_set_sprite(walkSpriteUp,	standingMask, _animSpeed);		break;
		}
		
		// On top of setting the proper walking animation, a footstep sound effect will be played whenever
		// the timer reaches a value of zero or lower relative to whatever it was set to after playing the
		// previous footstep. The interval between footsteps is relative to Samus's current animation speed.
		footstepTimer -= DELTA_TIME * _animSpeed;
		if (footstepTimer < 0.0){
			footstepTimer += PLYR_STEP_INTERVAL;
			play_sound_effect(snd_footstep, 0, false, true, 
				random_range(PLYR_STEP_MIN_VOLUME, PLYR_STEP_MAX_VOLUME), 
					random(0.03), random_range(0.95, 1.05));
		}
		return;
	}
	
	// The default sprites to use for this state, which are the standing sprites for Samus. There are two
	// possible sprites that can be set for this action: standing normally (same as aiming forward), or aiming
	// her beam upward.
	switch(_substate){
		default:					entity_set_sprite(standSpriteFw,	standingMask);	break;
		case PLYR_AIMING_UP:		entity_set_sprite(standSpriteUp,	standingMask);	break;
	}
}

/// @description The state Samus is assigned to whenever she finds herself no longer on the ground (Meaning
/// there is no longer a "collider" beneath her current collision mask). From here, she'll be able to aim 
/// directly downward, which is only possible in this state. On top of that, she'll be allowed to jump multiple
/// timers if the proper item has been acquired. Other than those differences, it will act nearly identical
/// to the default and morphball states, respectively.
state_airborne = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Calculating the gravity being applied to Samus for the frame. A check is performed below to see if she
	// has touched the floor. If she did, she will return from her airborne state to her default state, and
	// her horizontal velocity is reset as well as any jumping-specific substate flags.
	apply_gravity(PLYR_MAX_FALL_SPEED);
	if (DNTT_IS_GROUNDED){
		// Reset all variables that were altered by the airborne state and no longer required. Also reset
		// Samus's horizontal velocity to make it add to the impact of Samus landing. Also reset the light
		// source to act as the visor once again.
		stateFlags	   &= ~(PLYR_SOMERSAULT | PLYR_SCREWATK | PLYR_AIMING_DOWN | PLYR_SLOW_AIR_MOVEMENT);
		jumpStartTimer	= 0.0;
		aimReturnTimer	= 0.0;
		hspdFraction	= 0.0;
		hspd			= 0.0;
		jumpHspdFactor	= 1.0;
		reset_light_source();
		
		// Play a "thump" sound for Samus hitting the floor. On top of that, stop the "jump sound" if one
		// was currently playing (Only during somersault jump).
		play_sound_effect(snd_land, 0, false, true, PLYR_LAND_VOLUME, 0.0, random_range(0.9, 1.10));
		if (jumpSoundID != NO_SOUND){
			audio_stop_sound(jumpSoundID);
			jumpSoundID = NO_SOUND;
		}
		
		// Offset Samus by the difference between the bottom of her collision mask while airborne and her
		// collision mask for standing on the ground; ensuring she will be colliding perfectly with the floor
		// beneath her.
		var _bboxBottom	= bbox_bottom;
		mask_index		= standingMask;
		y			   -= bbox_bottom - _bboxBottom;
		
		// Check collision to see if Samus has something above her head and directly below her. If she does, 
		// switch over to her crouching state instead of her default.
		if (place_meeting(x, y, par_collider) && place_meeting(x, y + 1, par_collider)){
			object_set_next_state(state_crouching);
			entity_set_sprite(crouchSprite, crouchingMask);
			lightOffsetX = LGHT_VISOR_X_CROUCH;
			lightOffsetY = LGHT_VISOR_Y_CROUCH;
			return;
		}
		object_set_next_state(state_default);
		return; // State has changed; exit the function prematurely.
	}
	
	// When the jump input is activated, three possibilities can occur whilst airborune. The first is a check
	// for the double jump ability, which enables Samus to jump once more in the air regardless of if she's
	// somersaulting or not. The second will activate that somersaulting jump if she's moving horizontally 
	// and not aiming. Finally, a check for the space jump ability will occur if she's already in that 
	// somersaulting jump; allowing her to jump again indefinitely while in that same jump.
	if (PLYR_JUMP_PRESSED && jumpStartTimer == PLYR_FLIP_START_TIME){
		// Samus cannot be aiming in any direction to enable somersaulting in the air and her space jump.
		var _hasScrewAttack = event_get_flag(FLAG_SCREW_ATTACK);
		if (!PLYR_IS_AIMING_DOWN && !PLYR_IS_AIMING_UP){
			if (!PLYR_IN_SOMERSAULT){ // Entering a somersault jump when airborne.
				if (_hasScrewAttack){ // Toggle screw attack and play its sound effect.
					jumpSoundID = play_sound_effect(snd_screwattack, 0, false, true, 0);
					audio_sound_gain(jumpSoundID, PLYR_SCREWATK_VOLUME, 150);
					stateFlags |= PLYR_SCREWATK;
				} else{ // Play standard somersault sound effect.
					jumpSoundID = play_sound_effect(snd_somersault, 0, true, true, PLYR_SOMERSAULT_VOLUME);
				}
				stateFlags	   &= ~(PLYR_FIRING_CANNON | PLYR_AIMING_DOWN | PLYR_SLOW_AIR_MOVEMENT);
				stateFlags	   |= PLYR_SOMERSAULT;
				hspd			= get_max_hspd() * image_xscale * PLYR_SPIN_HSPD_FACTOR;
				jumpHspdFactor	= PLYR_SPIN_HSPD_FACTOR;
				aimReturnTimer	= 0.0;
				effectTimer		= PLYR_JUMP_INTERVAL;
			} else if (vspd >= 2.0 && event_get_flag(FLAG_SPACE_JUMP)){ // Utilizing Samus's Space Jump ability (Overwrites the double jump).
				vspd = get_max_vspd();
			}
		}
	}
	// Releasing the jump input before Samus has reached the apex of her jumping arc will cause the jump to
	// be lower than normal; allowing the player to control how high they want to jump based on how long they
	// hold the input for during said jump.
	if (PLYR_JUMP_RELEASED && vspd < 0.0) 
		vspd *= 0.5;
	
	// Process horizontal movement while airborne, which functions a bit different to how Samus moves while
	// on the ground. Her maximum velocity will be reduced to 40% if she isn't somersaulting -- 65% if she is, 
	// and her acceleration is reduced to 35%. On top of that, switching directions doesn't zero out her velocity.
	if (!PLYR_IS_MOVING_SLOW && abs(hspd) < 1.0){
		stateFlags |= PLYR_SLOW_AIR_MOVEMENT;
		if (PLYR_SOMERSAULT)	{jumpHspdFactor = PLYR_SPIN_HSPD_FACTOR;}
		else					{jumpHspdFactor = PLYR_JUMP_HSPD_FACTOR;}
	}
	var _prevDirection = image_xscale;
	process_horizontal_movement(jumpHspdFactor, 0.35, false, false);
	if (image_xscale != _prevDirection)
		lightOffsetX *= image_xscale;
	
	// Determine if Samus's downward aim should end depending on how long the player holds either the left
	// or right movement inputs for; much like how aiming down in the air functions in Super Metroid.
	if (movement != 0){
		if (PLYR_IS_AIMING_DOWN && !PLYR_DOWN_HELD){
			aimReturnTimer += DELTA_TIME;
			if (aimReturnTimer >= PLYR_AIM_BUFFER_TIME){
				stateFlags	   &= ~PLYR_AIMING_DOWN;
				aimReturnTimer	= 0.0;
			}
		}
	} else{ // Return timer to 0 to reset time needed to end downward aiming.
		aimReturnTimer = 0.0;
	}
	
	// When the up or down inputs have been presssed by the player, Samus will exit out of her somersault and
	// switch her aiming direction to whichever input was pressed. On top of that, Samus will reset her visor
	// light's positional offset/visibility and the somersaulting sound will be stopped.
	var _inSomersault	= PLYR_IN_SOMERSAULT;
	var _vInput			= sign(PLYR_DOWN_PRESSED - PLYR_UP_PRESSED);
	if (_inSomersault && _vInput != 0){
		audio_stop_sound(jumpSoundID);
		reset_light_source();
		stateFlags	   &= ~PLYR_SOMERSAULT;
		jumpSoundID		= NO_SOUND;
		_inSomersault	= false;	// Flag was flipped; flip the local boolean to reflect that.
	}
	
	// If "_vInput" is negative, Samus will aim upward. This has the side effect of making the visor light
	// invisible until Samus puts her arm cannon down. If "_vInput" is positive, Samus will aim downward, and
	// her visor's offset will update accordingly to be at her visor's position in the sprite.
	if (_vInput == -1){
		play_sound_effect(snd_aimcannon, 0, false, true, PLYR_AIMCANNON_VOLUME);
		if (!PLYR_IS_AIMING_DOWN){ // Aiming upward until the player releases their up input.
			stateFlags	&= ~(PLYR_FIRING_CANNON | PLYR_SCREWATK);
			stateFlags	|= PLYR_AIMING_UP;
			lightComponent.isActive = false;
		} else{ // Exiting from aiming downward.
			stateFlags	&= ~PLYR_AIMING_DOWN;
		}
		lightOffsetX = LGHT_VISOR_X_JUMP;
		lightOffsetY = LGHT_VISOR_Y_JUMP;
	} else if (_vInput == 1){
		if (!PLYR_IS_AIMING_DOWN){ // Entering a downward aiming state.
			play_sound_effect(snd_aimcannon, 0, false, true, PLYR_AIMCANNON_VOLUME);
			stateFlags	&= ~(PLYR_FIRING_CANNON | PLYR_AIMING_UP | PLYR_SCREWATK);
			stateFlags	|= PLYR_AIMING_DOWN;
			lightOffsetX = LGHT_VISOR_X_DOWN;
			lightOffsetY = LGHT_VISOR_Y_DOWN;
		} else if (event_get_flag(FLAG_MORPHBALL)){ // Entering morphball mode while in the air.
			var _bboxBottom		= bbox_bottom; // Store previous coordinate for southern edge of the bounding box.
			object_set_next_state(state_enter_morphball);
			entity_set_sprite(ballEnterSprite, morphballMask);
			play_sound_effect(snd_enter_morphball, 0, false, true, PLYR_TRANSFORM_VOLUME);
			y				   -= bbox_bottom - _bboxBottom;
			stateFlags		   &= ~(PLYR_AIMING_DOWN);
			stateFlags		   |= PLYR_MORPHBALL;
			jumpStartTimer		= 0.0;
			return;
		}
	} else if (PLYR_UP_RELEASED){ // Stopping Samus from aiming upward.
		stateFlags &= ~PLYR_AIMING_UP;
		lightComponent.isActive = true;
	}
	
	// Activating the Phase Shift ability, which instantly exists the current state if the function returned
	// true. Otherwise, the ability cannot be activated and won't cause the current state to prematurely end.
	if (PLYR_PSHIFT_PRESSED && activate_phase_shift(movement))
		return;
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();
	
	// When Samus isn't using her screw attack, the ambient light position is updated to match Samus's visor's
	// position during her somersaulting jump animation depending on the current frame of the animation that
	// is visible on-screen.
	if (_inSomersault && jumpStartTimer == PLYR_FLIP_START_TIME){
		// Update offset of the light to match where Samus's visor is for each frame of her somersault.
		switch(floor(imageIndex)){
			case 0: // Visor is on top of the image.
				lightOffsetX = LGHT_VISOR_X_FLIP0;
				lightOffsetY = LGHT_VISOR_Y_FLIP0;
				break;
			case 1: // Visor is to the right of the image.
				lightOffsetX = LGHT_VISOR_X_FLIP1;
				lightOffsetY = LGHT_VISOR_Y_FLIP1;
				break;
			case 2: // Visor is on the bottom of the image.
				lightOffsetX = LGHT_VISOR_X_FLIP2;
				lightOffsetY = LGHT_VISOR_Y_FLIP2;
				break;
			case 3: // Visor is on the left of the image.
				lightOffsetX = LGHT_VISOR_X_FLIP3;
				lightOffsetY = LGHT_VISOR_Y_FLIP3;
		}
		
		// The light effect that occurs when Samus is using her screw attack, which will vastly increase the 
		// size and brightness of the light; moving it to the center of her animation for the duration. The 
		// visor light is replaced by this light.
		if (PLYR_IN_SCREWATK){
			with(lightComponent){
				set_properties(LGHT_SCREWATK_RADIUS + irandom_range(-10, 10), 
					choose(HEX_LIGHT_GREEN, HEX_LIGHT_BLUE, HEX_LIGHT_PURPLE, HEX_WHITE), 
					LGHT_SCREWATK_STRENGTH + random_range(-0.2, 0.1));
			}
			lightOffsetX = LGHT_SCREWATK_X;
			lightOffsetY = LGHT_SCREWATK_Y;
		}
		
		// Producing the ghosting effect for Samus's somersault, which leaves an instance of Samus that 
		// quickly fades out. This effect is created at a regular interval until she is no longer somersaulting.
		effectTimer += DELTA_TIME;
		if (effectTimer >= PLYR_JUMP_INTERVAL){
			create_ghosting_effect(c_white, 0.5, false);
			effectTimer -= PLYR_JUMP_INTERVAL;
		}
	} else if (_vInput == 0 && jumpStartTimer >= PLYR_JUMP_START_TIME){
		lightOffsetX = LGHT_VISOR_X_JUMP;
		lightOffsetY = LGHT_VISOR_Y_JUMP;
	}
	
	// Code that is ran when Samus is executing a somersault jump after she has collected the Screw Attack.
	// It checks for collision against destructible objects in the world that are weak to the ability, and 
	// will loop the sound effect in a sporadic fashion to simulate an "electrical/zapping" sound.
	if (PLYR_IN_SCREWATK){
		destructible_screw_attack_collision();

		var _position = audio_sound_get_track_position(jumpSoundID);
		if (_position >= audio_sound_length(jumpSoundID) * 0.9 || !audio_is_playing(jumpSoundID))
			audio_sound_set_track_position(jumpSoundID, random_range(0.05, 0.25));
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_item_drop_collision();
	player_liquid_collision();
	player_enemy_collision();
	player_warp_collision();
	
	// Counting down the time that prevents Samus from somersalting or showing her jump sprites (Excluding the
	// downward facing jump sprite) in order to display their respective intro animations, which are all based
	// on this timer's value against specific macro values.
	if (jumpStartTimer < PLYR_FLIP_START_TIME){
		jumpStartTimer += DELTA_TIME;
		if (jumpStartTimer > PLYR_FLIP_START_TIME){
			jumpStartTimer = PLYR_FLIP_START_TIME;
			
			// Begin playing the somersaulting sound effect here since this is where the animation truly starts
			// after executing a jump. This sound differs depending on if Samus has the screw attack or not.
			if (PLYR_IN_SCREWATK){
				jumpSoundID = play_sound_effect(snd_screwattack, 0, false, true, 0.0);
				audio_sound_gain(jumpSoundID, PLYR_SCREWATK_VOLUME, 150); // Start from 0% volume and smoothly increase over 0.15s of time.
			} else if (_inSomersault){
				jumpSoundID = play_sound_effect(snd_somersault, 0, true, true, PLYR_SOMERSAULT_VOLUME);
			}
		}
	}
	
	// Samus has completed the pre-somersault animation. From that point until she ends her somersault, she
	// should only be in that single animation, so no other checks are done for the remaining jump substates.
	if (_inSomersault && jumpStartTimer == PLYR_FLIP_START_TIME){
		entity_set_sprite(jumpSpriteSpin, jumpingMask, 1.0, 0.0);
		return;
	}
	
	// Samus has her animation set by this section of code depending on if she's still transitioning between
	// standing and somersaulting or if she's simply in the air; aiming up or down depending on the aiming
	// substate flags.
	var _substate = stateFlags & (PLYR_FIRING_CANNON | PLYR_AIMING_UP| PLYR_AIMING_DOWN);
	if (jumpStartTimer >= PLYR_JUMP_START_TIME){
		switch(_substate){
			default:					entity_set_sprite(jumpSpriteFw, jumpingMask);	break;
			case PLYR_AIMING_UP:		entity_set_sprite(jumpSpriteUp, jumpingMask);	break;
			case PLYR_AIMING_DOWN:		entity_set_sprite(jumpSpriteDown, jumpingMask);	break;
		}
		return; // No need to set an intro animation sprite, so return early.
	}

	// Samus is in her transitional animation between standing and jumping, so apply the animation
	// frame that matches with the direction she's aiming her arm cannon (Excluding aiming down).
	switch(_substate){
		default:					entity_set_sprite(walkSpriteFw, standingMask, 0.0); break;
		case PLYR_AIMING_UP:		entity_set_sprite(walkSpriteUp, standingMask, 0.0); break;
	}
	imageIndex = 0.0; // Always use the first frame of animation during the transition.
}

/// @description The state that is executed whenever Samus is crouching. During said state she will be unable
/// to move horizontally or jump. Hitting the left or right movement inputs will simply face Samus in the
/// direction of the last of those inputs that was pressed.
state_crouching = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// 
	if (grounded_to_airborne())
		return;
	
	// By pressing the up OR the jump input, Samus will exit her crouching state.
	if (PLYR_UP_PRESSED || PLYR_JUMP_PRESSED){
		crouch_to_standing();
		return; // State was changed; don't process any more code in this function.
	}
	
	// Entering Samus's morphball mode, which involves her passing through a "passing" state that will then
	// determine if she'll enter or exit morphball (She'll always enter morphball when set to that state by
	// this bit of code).
	if (PLYR_DOWN_PRESSED && event_get_flag(FLAG_MORPHBALL)){
		object_set_next_state(state_enter_morphball);
		entity_set_sprite(ballEnterSprite, morphballMask);
		play_sound_effect(snd_enter_morphball, 0, false, true, PLYR_TRANSFORM_VOLUME);
		stateFlags |= PLYR_MORPHBALL;
		return; // State was changed; don't process any more code in this function.
	}
	
	// Hitting the right or left movement keys, which will simply change Samus's facing direction when pressed.
	// When either input is held down for a specific amount of time, Samus will exit her crouching state.
	movement = PLYR_RIGHT_HELD - PLYR_LEFT_HELD;
	if (movement != 0){
		standingTimer += DELTA_TIME;
		if (standingTimer >= PLYR_STAND_UP_TIME){
			crouch_to_standing();
			standingTimer = 0.0;
		}
		lightOffsetX = LGHT_VISOR_X_GENERAL;
		image_xscale = movement;
	} else{ // Reset timer for making Samus stand through left or right input when they are released early.
		standingTimer = 0.0;
	}
	
	// Call the functions that update Samus's arm cannon; counting down its timers for the currently in-use 
	// weapon's as well as the timer for charging the current beam (If the charge beam has been unlocked).
	// The second function will handle weapon/beam swapping for this state.
	update_arm_cannon(movement);
	check_swap_current_weapon();
	
	// Allow collisions against the enemy when Samus is crouching by calling the function for dealing with
	// said collisions.
	player_enemy_collision();
}

/// @description A passing state that will play Samus's one-frame animation for entering her morphball form.
/// The time for this transition being determined by the value of the "PLYR_ENTER_BALL_TIME" macro that is
/// defined at the top of this event's code.
state_enter_morphball = function(){
	// Despite the playing not being in control during this state, Samus can still be damaged by entities if
	// she comes into contact with one while in this standard/morphball transition state.
	player_enemy_collision();
	
	// 
	mBallTransformTimer += DELTA_TIME;
	if (mBallTransformTimer < PLYR_ENTER_BALL_TIME){
		lightOffsetX	= LGHT_VISOR_X_TRANSFORM;
		lightOffsetY	= LGHT_VISOR_Y_TRANSFORM;
		return;
	}
		
	// 
	object_set_next_state(state_morphball);
	entity_set_sprite(morphballSprite, morphballMask);
	stateFlags		   &= ~(PLYR_AIMING_DOWN | PLYR_CROUCHED);
	curWeapon			= curBeam;
	mBallTransformTimer = 0.0;
	
	// 
	lightComponent.isActive = false;
}

/// @description 
state_exit_morphball = function(){
	// Despite the playing not being in control during this state, Samus can still be damaged by entities if
	// she comes into contact with one while in this standard/morphball transition state.
	player_enemy_collision();
	
	// 
	mBallTransformTimer += DELTA_TIME;
	if (mBallTransformTimer < PLYR_EXIT_BALL_TIME){
		lightOffsetX	= LGHT_VISOR_X_TRANSFORM;
		lightOffsetY	= LGHT_VISOR_Y_TRANSFORM;
		return;
	}
	
	// 
	stateFlags		   &= ~PLYR_MORPHBALL;
	mBallTransformTimer = 0.0;
	reset_light_source();
	
	// 
	if (!DNTT_IS_GROUNDED){
		object_set_next_state(state_airborne);
		var _bboxBottom = bbox_bottom;
		entity_set_sprite(jumpSpriteFw, jumpingMask);
		y			   -= bbox_bottom - _bboxBottom;
		vspd			= 0.0;
		jumpStartTimer	= PLYR_JUMP_START_TIME;
		lightOffsetX	= LGHT_VISOR_X_JUMP;
		lightOffsetY	= LGHT_VISOR_Y_JUMP;
		return;
	}
	
	// 
	object_set_next_state(state_crouching);
	entity_set_sprite(crouchSprite, crouchingMask);
	stateFlags	   |= PLYR_CROUCHED;
	standingTimer	= 0.0;
	hspdFraction	= 0.0;
	hspd			= 0.0;
	lightOffsetX	= LGHT_VISOR_X_CROUCH;
	lightOffsetY	= LGHT_VISOR_Y_CROUCH;
}

/// @description The state Samus exists in whenever she's inside her morphball. It functions somewhat like 
/// how her standard state does--with the main exceptions being her aiming direction and arm cannon cannot
/// be interacted with and manipulated. Instead, she can utilize bombs if she has access to them.
state_morphball = function(){
	// First, player input is processed for the frame by calling the function responsible for handling that
	// logic within the player object. Must be done first to avoid inputs from the previous frame triggering
	// code on this frame when it really shouldn't have.
	process_input();
	
	// Applying gravity and also the recoil that can occur when the morphball hits the ground especially hard.
	// If the vertical velocity is low enough, no bounce will occur, but until then a bounce will make the
	// morphball airborune again until that velocity threshold is passed.
	var _vspd			= vspd;
	var _wasAirbourne	= !DNTT_IS_GROUNDED;
	apply_gravity(PLYR_MAX_FALL_SPEED);
	if (_wasAirbourne && DNTT_IS_GROUNDED){
		play_sound_effect(snd_land_morphball, 0, false, true, PLYR_MORPHLAND_VOLUME, 0.0, random_range(0.95, 1.05));
		if (_vspd >= PLYR_MBALL_BOUNCE_VSPD){ // Make the Morphball bounce.
			stateFlags &= ~DNTT_GROUNDED;
			vspd		= -(_vspd * 0.5);
			hspd	   *= 0.5;
		} else{
			// Toggle the "moving" substate bit so Samus doesn't decelerate after being blasted horizontally
			// by her offset from the center of a bomb's explosion. Otherwise, stop Samus's horizontal velocity
			// upon impact with the ground.
			if (!PLYR_IS_MOVING && hspd != 0.0)	{stateFlags |= PLYR_MOVING;}
			else								{hspd = 0.0;}
		}
	}
	
	// Handling the morphball's jumping capabilities, which are unlocked after Samus collects the "Spring Ball"
	// upgrade. Once acquired, Samus can press the jump input while grounded to jump into the air as she would
	// while in her suit form.
	if (PLYR_JUMP_PRESSED && DNTT_IS_GROUNDED && event_get_flag(FLAG_SPRING_BALL)){
		play_sound_effect(snd_jumpstart, 0, false, true, PLYR_JUMPSTART_VOLUME);
		vspd		= PLYR_BASE_JUMP * maxVspdFactor;
		stateFlags &= ~DNTT_GROUNDED;
	}
	if (PLYR_JUMP_RELEASED && vspd < 0.0) 
		vspd /= 2;
	
	// Handling horizontal movement while in morphball mode, which functions very similar to how said movement
	// works in Samus's default suit form. Holding left or right (But not both at once) will result in her
	// moving in the desired direction; releasing said key will slow her down until she is no longer moving.
	var _hspdFactor  = place_meeting(x + sign(movement), y, obj_collider_slope) ? 0.7 : 1.0;
	var _isGrounded	 = DNTT_IS_GROUNDED;
	var _accelFactor = _isGrounded ? 0.6 : 0.3;
	process_horizontal_movement(_hspdFactor, _accelFactor, _isGrounded, _isGrounded);

	// Exiting out of morphball mode, which will call the function that checks for a collision directly above
	// Samus's head. If there's a collision, she'll be unable to transform back into her standard form.
	if (PLYR_UP_PRESSED){
		play_sound_effect(snd_exit_morphball, 0, false, true, PLYR_TRANSFORM_VOLUME);
		morphball_to_crouch();
		return; // State potentially changed; exit the current state function prematurely.
	}
	
	// Using the standard bombs (If the auxilliary weapon input isn't pressed OR the player doesn't have
	// access to the power bombs yet) or power bombs if the player has access to them. Both require the
	// timer for bomb use to be zero, and both will set the timer to different amount to differentiate
	// how often each can be used.
	if (PLYR_USE_PRESSED && bombDropTimer == 0.0){
		if (PLYR_ALT_WEAPON_HELD && numPowerBombs > 0 && event_get_flag(FLAG_POWER_BOMBS)){ // Deploying a power bomb.
			var _maxHitpoints = 0; // Copy the value for maximum hitpoints for the bomb drop timer.
			with(instance_create_object(x, y - 5, obj_player_power_bomb, depth - 1)){
				_maxHitpoints = maxHitpoints;
				initialize(state_default);
			}
			bombDropTimer = _maxHitpoints + 30.0; // Lasts half a second longer than the power bomb explosion's full length.
			numPowerBombs--;
		} else if (event_get_flag(FLAG_BOMBS) && instance_number(obj_player_bomb) < PLYR_MAX_BOMBS){ // Deploying a standard bomb.
			with(instance_create_object(x, y - 5, obj_player_bomb, depth - 1))
				initialize(state_default);
			bombDropTimer = PLYR_BOMB_SET_INTERVAL;
		}
	}
	
	// Counting down the timer that prevents spamming morphball bombs with each push of the "use weapon" input.
	// Once this timer hits zero again, another bomb can be deployed should the player choose to do so.
	if (bombDropTimer > 0.0){
		bombDropTimer -= DELTA_TIME;
		if (bombDropTimer <= 0.0) 
			bombDropTimer = 0.0;
	}
	
	// Handling the bomb expolosion's physics. It will move Samus to either the left or the right depending on
	// where she is positioned relative to the center of the bomb's explosion. On top of that, the morphball
	// will shot up based on the bomb's set jump height.
	var _id = instance_place(x, y, obj_player_bomb_explode);
	if (bombExplodeID != _id && _id != noone && y <= _id.y + 10){
		stateFlags	   &= ~PLYR_MOVING; // Allows preservation of velocity from bomb jump.
		bombExplodeID	= _id;
		vspd			= PLYR_BOMB_JUMP_VSPD;
		hspd			= ((x - _id.x) / 12.0) * maxHspd;
	}
	
	// Call a function that was inherited from the parent object; updating the position of Samus for the 
	// current frame of gameplay--accounting for and applying delta time on the hspd and vspd values determined
	// throughout the state.
	apply_frame_movement(entity_world_collision);
	player_collectible_collision();
	player_item_drop_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	player_enemy_collision();
	player_warp_collision();
	
	// Assign the morphball's sprite, and update its image speed based on whatever its current horizontal
	// movement factor is set to (Ex. A factor of 0.5 would make the morphball animate at half its normal
	// speed, and so on).
	entity_set_sprite(morphballSprite, morphballMask, animSpeed);
}

/// @description Samus's state for phase shifting, which only ends its execution once one of two conditions
/// have been met: the range of the shift has been reached, or a wall has been hit. Until then, the only 
/// thing the player can do is time another press of the phase shift input to potentially trigger a quick
/// shift, which doubles the distance of the shift at twice the cost; ignoring the aeion cooldown.
state_phase_shift = function(){
	// Doubles the distance of the phase shift if the player manages to press its activation input while Samus
	// is between 30 and 80 pixels from her initial position prior to the phase shift. She also needs to have
	// at least 50 aeion remaining to activate a double phase shift.
	if (curAeion >= PLYR_PSHIFT_COST && curShiftDist >= PLYR_PSHIFT_DISTANCE - 50){
		if (keyboard_check_pressed(KEYCODE_PHASE_SHIFT)){
			curAeion	 -= PLYR_PSHIFT_COST;
			curShiftDist -= PLYR_PSHIFT_DISTANCE;
		}
	}
	
	// Since vertical velocity isn't processed during a phase shift, Samus's horizontal velocity is the only
	// value that is converted from floating point to an integer; storing the fractional value until a whole
	// number can be parsed from it.
	var _deltaHspd	= hspd * DELTA_TIME;
	_deltaHspd	   += hspdFraction;
	hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * sign(_deltaHspd));
	_deltaHspd	   -= hspdFraction;
	
	// Store Samus's last x position and then call her movement/collision function. Then, the current shift
	// distance value is incremented by the difference in Samus's x position prior to and after movement and
	// collisions have been processed.
	var _lastX = x;
	entity_world_collision(_deltaHspd, 0, false);
	curShiftDist += abs(_lastX - x);
	
	// Go through all of the standard collision functions. However, enemies will be ignored since Samus is
	// technically phasing through them when using this ability; creating a dodge mechanic with this ability.
	player_collectible_collision();
	player_item_drop_collision();
	fallthrough_floor_collision();
	player_liquid_collision();
	player_warp_collision();
	
	// Check if Samus has moved the required distance for a phase shift (Or she was stopped by a collision that
	// set her horizontal velocity to 0). If so, she'll return to her previous state.
	if (curShiftDist >= PLYR_PSHIFT_DISTANCE || hspd == 0.0){
		// Since gravity isn't updated during the ability, a check to see if Samus is airborne after it has
		// ended will occur so she isn't set back to her "grounded" state despite that not being the case.
		if (place_meeting(x, y + 1, par_collider))	{object_set_next_state(lastState);}
		else										{object_set_next_state(state_airborne);}
		
		reset_light_source();
		stateFlags	   &= ~PLYR_PHASE_SHIFT;
		stateFlags	   |=  ENTT_DRAW_SELF;
		curShiftDist	= 0;
		hspd			= 0.0;
		maxHspd			= prevMaxHspd;
		animSpeed		= prevAnimSpeed;
		return;
	}
	
	// Increment the timer by delta time until the effect interval's value has been reached or exceeded. If so,
	// a "ghost" of Samus will be created as part of the phase shift's animation.
	effectTimer += DELTA_TIME;
	if (effectTimer >= PLYR_SHIFT_INTERVAL){
		create_ghosting_effect(HEX_LIGHT_BLUE, 0.75, armCannon.visible);
		effectTimer -= PLYR_SHIFT_INTERVAL;
	}
	
	// Samus's ambient light will slowly dim over the duration of the phase shift.
	var _distance = curShiftDist;
	with(lightComponent) {strength = 1.0 - ((_distance / PLYR_SHIFT_INTERVAL) * 0.85);}
}

#endregion

// SET A UNIQUE COLOR FOR SAMUS'S BOUNDING BOX (FOR DEBUGGING ONLY)
collisionMaskColor = HEX_LIGHT_BLUE;

event_set_flag(FLAG_MORPHBALL, true);
//event_set_flag(FLAG_BOMBS, true);
//event_set_flag(FLAG_SPRING_BALL, true);
//event_set_flag(FLAG_POWER_BOMBS, true);
//event_set_flag(FLAG_SPACE_JUMP, true);
//event_set_flag(FLAG_SCREW_ATTACK, true);
//jumpSpriteSpin = spr_power_jump0b;