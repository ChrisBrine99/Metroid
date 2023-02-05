/// @description 

#region Initializing any macros that are useful/related to obj_player

// Important values for Samus. The first value being related to her maximum falling speed and the remaining
// values being timer-related values for entering/manipulating/exiting certain substates or performing certain
// actions during gameplay.
#macro	BASE_JUMP_HEIGHT	   -5.1		// Jump height for Samus without "Hi-jump Boots" and her spring ball upgrade.
#macro	HI_JUMP_HEIGHT		   -7		// Samus's enhanced jumping height after she acquires the "Hi-jump Boots".
#macro	MAX_FALL_SPEED			8		// Max speed in pixels per 1/60th of a second that Samus can fall downward.
#macro	AIM_SWITCH_TIME			5.8		// How fast Samus's aim switches from forward to upward while holding the up input after exiting her crouch state.
#macro	BEAM_LOWER_TIME			15		// Time in a 60FPS interval between the last beam fired OR the weapon use button being released and Samus lowering her arm cannon whilst walking.
#macro	STAND_UP_TIME			10		// Holding the left or right inputs while crouching for this duration will have Samus automatically stand up.
#macro	MORPHBALL_ANIM_TIME		1.8		// How long the one-frame morphbal enter/exit animation lasts.
#macro	JUMPSPIN_ANIM_TIME		4		// Time equal to 60 units per second that before starting the jumpspin animation.
#macro	MIN_CHARGE_TIME			55		// Holding the fire button for this or longer will allow the beam fired to be charged.
#macro	MAX_CHARGE_TIME			80		// Time until the end of the charge animation (Where it begins to loop).

// Variables for Samus's morphball bombs; the top value being how fast she can deploy them (Calculated as 60
// being one second of real-worl time) and the lower value being the max number of bombs Samus can actively
// deploy at any given time.
#macro	BOMB_DROP_RATE			5
#macro	MAX_STANDARD_BOMBS		3

// Bit flags that are unique to Samus. Each one can be flipped on (A value of 1) or off (A value of 0) to have
// certain things occur during gameplay, alter animations, or alter Samus' movement/attacking capabilities.
#macro	MOVING					0
#macro	CROUCHING				1
#macro	JUMP_SPIN				2
#macro	JUMP_ATTACK				3		// Screw Attack's damaging/invincibility effect
#macro	AIMING_UP				4
#macro	AIMING_DOWN				5
#macro	AIMING_FRONT			6
#macro	MORPHBALL				7
#macro	SUBMERGED				8

// Condenses the logic required to check if certain substate bits are set or not.
#macro	IS_MOVING				(stateFlags & (1 << MOVING) != 0)
#macro	IS_AIMING				(stateFlags & ((1 << AIMING_FRONT) | (1 << AIMING_UP) | (1 << AIMING_DOWN)) != 0)
#macro	IS_JUMP_SPIN			(stateFlags & (1 << JUMP_SPIN) != 0)
#macro	IS_JUMP_ATTACK			(stateFlags & (1 << JUMP_ATTACK) != 0)
#macro	IN_MORPHBALL			(stateFlags & (1 << MORPHBALL) != 0)
#macro	IS_SUBMERGED			(stateFlags & (1 << SUBMERGED) != 0)

// Input bit flags for Samus. Each corresponding to an action that the user can make Samus perform within the
// game (The said action depending on what state and substate(s) Samus is currently in).
#macro	MOVE_RIGHT				0
#macro	MOVE_LEFT				1
#macro	AIM_UP					2
#macro	AIM_DOWN				3
#macro	JUMP					4
#macro	USE_WEAPON				5

// These macros condense all the code required to check if a valid input is being pressed or held by the player.
#macro	IS_RIGHT_HELD			(inputFlags & (1 << MOVE_RIGHT) != 0)
#macro	IS_LEFT_HELD			(inputFlags & (1 << MOVE_LEFT) != 0)
#macro	IS_UP_HELD				(inputFlags & (1 << AIM_UP) != 0)
#macro	IS_UP_PRESSED			((inputFlags & (1 << AIM_UP) != 0) && (prevInputFlags & (1 << AIM_UP) == 0))
#macro	IS_UP_RELEASED			((inputFlags & (1 << AIM_UP) == 0) && (prevInputFlags & (1 << AIM_UP) != 0))
#macro	IS_DOWN_HELD			(inputFlags & (1 << AIM_DOWN) != 0)
#macro	IS_DOWN_PRESSED			((inputFlags & (1 << AIM_DOWN) != 0) && (prevInputFlags & (1 << AIM_DOWN) == 0))
#macro	IS_DOWN_RELEASED		((inputFlags & (1 << AIM_DOWN) == 0) && (prevInputFlags & (1 << AIM_DOWN) != 0))
#macro	IS_JUMP_PRESSED			((inputFlags & (1 << JUMP) != 0) && (prevInputFlags & (1 << JUMP) == 0))
#macro	IS_JUMP_RELEASED		((inputFlags & (1 << JUMP) == 0) && (prevInputFlags & (1 << JUMP) != 0))
#macro	IS_USE_HELD				(inputFlags & (1 << USE_WEAPON) != 0)
#macro	IS_USE_PRESSED			((inputFlags & (1 << USE_WEAPON) != 0) && (prevInputFlags & (1 << USE_WEAPON) == 0))
#macro	IS_USE_RELEASED			((inputFlags & (1 << USE_WEAPON) == 0) && (prevInputFlags & (1 << USE_WEAPON) != 0))

// Each value corresponds to a bit found within the "curWeapon" variable, which determines what weapon Samus
// currently has equipped to her arm cannon. "Equipped" means firing her arm cannon will result in that beam
// or missile being shot from it.
#macro	POWER_BEAM				0
#macro	ICE_BEAM				1
#macro	TESLA_BEAM				2
#macro	PLASMA_BEAM				3
#macro	MISSILE					4
#macro	ICE_MISSILE				5
#macro	SHOCK_MISSILE			6

// A simple macro to condesne the code that is required to check if the currently equipped weapon within the
// arm cannon is a missile or not; of which there are three possible missile to have equipped.
#macro	IS_MISSILE_EQUIPPED		(curWeapon & ((1 << MISSILE) | (1 << ICE_MISSILE) | (1 << SHOCK_MISSILE)))

#endregion

#region Initializing enumerators that are useful/related to obj_player
#endregion

#region Initializing any globals that are useful/related to obj_player
#endregion

#region Global functions related to obj_player
#endregion