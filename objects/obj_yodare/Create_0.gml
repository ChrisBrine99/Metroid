#region Macro initialization

// Bits that represent state flags utilized by the Yodare's AI; allowing it to perform certain actions and make
// certain checks depending on the values stored at their respective bit positions.
#macro	YDRE_IN_CEILING			0x00000001
#macro	YDRE_IN_FLOOR			0x00000002

// Macros that automate having to type out a bitwise AND check against the state flags that are unique to the
// Yodare. They determine if it's currently in the "ceiling" (Collider it spawned into) or the "floor" (Collider
// that is below what it considers its ceiling).
#macro	YDRE_IS_IN_CEILING		(stateFlags & YDRE_IN_CEILING)
#macro	YDRE_IS_IN_FLOOR		(stateFlags & YDRE_IN_FLOOR)

// Determines the maximum vertical speed that the Yodare will move at when it is moving through any collider.
#macro	YDRE_BURROW_SPEED		0.2

// Time in "unit frames" (60 unit frames = 1 second) that it takes the Yodare to reset its y position to what
// it originally started at; making it look like another Yodare is burrowing out of the nest.
#macro	YDRE_RETURN_TIME		80.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// The Yodare only ever travel downward; having its velocity determined by the effect of gravity relatiive to
// its terminal velocity, which is stored in "maxVspd". Also determine the speed of gravity for the Yodare.
maxVspd = 8.0;
vAccel	= 0.25;

// Since the Power Beam deals a single point of damage (On "Normal" difficulty), the Yodare will be able to take
// two hits before dying. Other beams and missiles will change the amount of hits needed, obviously.
maxHitpoints	= 2;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Yodare. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 10;
stunDuration	= 12;

// Determine the chances of energy orbs, aeion, missile, and power bomb drops through setting the inherited
// variables storing those chances here.
energyDropChance	= 0.25;	// 25%
aeionDropChance		= 0.25;	// 25%
ammoDropChance		= 0.40;	// 40%

#endregion

#region Unique variable initialization

// Value that is set upon initialization of the Yodare that stores the y position is was at during that time.
// Used to reset itself once it gets reset from burrowing through what it considers a "floor".
startY = 0;

// Tracks the amount of time that the Yodare has been burrowing through the "floor" for in unit frames; where
// 60 units make up one second of real-world time.
returnTimer = 0.0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Yodare, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Yodare. It sets its sprite, and sets it to be weak to all 
/// forms of weaponry. On top of that, its initial state is set while a check to see if its in a "ceiling" is
/// performed to determine the Yodare's reset point on the y-axis.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_yodare, -1);
	create_general_collider();
	
	// Set up weakness flags such that the Yodare is weak to every type of weapon Samus can utilize.
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
	
	// Consider whatever collider the Yodare first comes into contact with as the "ceiling". If there is no
	// collision detected, the Yodare will instantly be destroyed.
	if (place_meeting(x, y, par_collider)){
		stateFlags |= YDRE_IN_CEILING;
		vspd		= YDRE_BURROW_SPEED;
		startY		= y;
	} else{
		stateFlags |= ENTT_DESTROYED;
	}
}

#endregion

#region State function initialization

/// @description The Yodare's default and only state, which will have it burrowing through the ground/ceiling
/// at a slow speed; falling at increase speeds due to gravity when not burrowing through something solid.
state_default = function(){
	// Handling vertical movement, which borrows its logic from the general "apply_frame_movement" function
	// without the code for handling horizontal movement since the Yodare never moves horizontally.
	var _deltaVspd	= vspd * DELTA_TIME;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * sign(_deltaVspd));
	_deltaVspd	   -= vspdFraction;
	y			   += _deltaVspd;
	
	// While burrowing through the ceiling, the Yodare will check to see if it is no longer within the ceiling
	// by performing an "inverted gravity" check (Gravity uses y + 1 to determine if an Entity is on the floor
	// or not). If the check passes, the "IN_CEILING" bit is flipped to zero.
	if (YDRE_IS_IN_CEILING){
		if (!place_meeting(x, y - 1, par_collider))
			stateFlags &= ~YDRE_IN_CEILING;
		return; // No other state functionality allowed while in ceiling.
	}
	
	// While not in the ceiling AND not burrowing into the floor, the Yodare will fall relative to the effect
	// of gravity (Its "vAccel" value) on it; maxing out at the value stored in "maxVspd". While in the floor,
	// the Yodare will begin burrowing again and no longer be affectd by gravity.
	if (!YDRE_IS_IN_FLOOR){
		vspd += vAccel * DELTA_TIME;
		if (vspd > maxVspd) {vspd = maxVspd;}
		
		// Perform a standard gravity check like the function "apply_gravity" would, but in the Yodare's case
		// it will simply flip the "IN_FLOOR" bit to 1 while returning its vertical velocity back to its speed
		// while burrowing through a solid object.
		if (place_meeting(x, y + 1, par_collider)){
			stateFlags |= YDRE_IN_FLOOR;
			vspd		= YDRE_BURROW_SPEED;
		}
	} else{
		returnTimer += DELTA_TIME;
		if (returnTimer >= YDRE_RETURN_TIME){
			// UNIQUE CASE -- Perform a check to see if the nest that the Yodare originally came from has been
			// destroyed or not. If so, the Yodare will destroy itself alongside the spawner.
			if (!instance_exists(linkedSpawnerID)){
				stateFlags |= ENTT_DESTROYED;
				return;
			}
			
			// Flip the "IN_FLOOR" bit to 0 while also setting the "IN_CEILING" bit, and then reset the Yodare's
			// vertical position back to its starting y position to burrow back out of the nest again. 
			stateFlags	&= ~YDRE_IN_FLOOR;
			stateFlags	|=  YDRE_IN_CEILING;
			returnTimer	 = 0.0;
			y			 = startY;
		}
	}
}

#endregion

// Set the Yodare to its default state upon creation.
initialize(state_default);