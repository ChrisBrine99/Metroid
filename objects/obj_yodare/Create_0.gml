#region Macro initialization

// 
#macro	IN_CEILING				0
#macro	IN_FLOOR				1

// 
#macro	IS_IN_CEILING			(stateFlags & (1 << IN_CEILING))
#macro	IS_IN_FLOOR				(stateFlags & (1 << IN_FLOOR))

// 
#macro	BURROWING_SPEED			0.2

// 
#macro	TIME_FOR_RETURN			80.0

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

// 
startY = 0;

// 
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
	initialize_weak_to_all();
	
	// Consider whatever collider the Yodare first comes into contact with as the "ceiling". If there is no
	// collision detected, the Yodare will instantly be destroyed.
	if (place_meeting(x, y, par_collider)){
		stateFlags |= (1 << IN_CEILING);
		vspd		= BURROWING_SPEED;
		startY		= y;
	} else{
		stateFlags |= (1 << DESTROYED);
	}
}

#endregion

#region State function initialization

/// @description 
state_default = function(){
	// 
	var _deltaVspd	= vspd * DELTA_TIME;
	_deltaVspd	   += vspdFraction;
	vspdFraction	= _deltaVspd - (floor(abs(_deltaVspd)) * sign(_deltaVspd));
	_deltaVspd	   -= vspdFraction;
	y			   += _deltaVspd;
	
	// 
	if (IS_IN_CEILING){
		if (!place_meeting(x, y - 1, par_collider))
			stateFlags &= ~(1 << IN_CEILING);
		return;
	}
	
	// 
	if (!IS_IN_FLOOR){
		// 
		vspd += vAccel * DELTA_TIME;
		if (vspd > maxVspd) {vspd = maxVspd;}
		
		// 
		if (place_meeting(x, y + 1, par_collider)){
			stateFlags |= (1 << IN_FLOOR);
			vspd		= BURROWING_SPEED;
		}
	} else{
		returnTimer += DELTA_TIME;
		if (returnTimer >= TIME_FOR_RETURN){
			stateFlags	&= ~(1 << IN_FLOOR);
			stateFlags	|=  (1 << IN_CEILING);
			returnTimer	 = 0.0;
			y			 = startY;
		}
	}
}

// Set the Yodare to its default state upon creation.
initialize(state_default);

#endregion