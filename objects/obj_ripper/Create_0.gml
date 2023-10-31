#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();

// Set the maximum horizontal speed and acceleration for the Ripper. Its speed is set to 0 after it bounces
// off a wall, and as such will smoothly speed back up to its max velocity.
maxHspd = 0.8;
hAccel	= 0.2;

// Despite being invulnerable to nearly all forms of weaponry that Samus can utilize, the ripper will only
// have a single point of hp within the code; guarenteeing its death against super missiles or a power bomb.
// Having an HP value of one also allows the ripper to be frozen even if it isn't damaged by the ice-based
// weapon utilized.
maxHitpoints	= 1;
hitpoints		= maxHitpoints;

// Set the damage output and hitstun duration for the Ripper. These values are increased/decreased by the
// difficulty level selected by the player.
damage			= 10;
stunDuration	= 12;

#endregion

#region Unique variable initialization

// Determines the direction that the Ripper is currently moving in; right or left.
movement = 0;

#endregion

#region Initiaize function override

/// Store the pointer for the parent's initialize function into a local variable for the Ripper, which is then
/// called inside its own initialization function so the original functionality isn't ignored.
__initialize = initialize;
/// @description Initialization function for the Ripper. It sets its sprite, creates an ambient light for its
/// eye, and sets it to be weak to Super Missiles only. It will set its initial state while also setting up its 
/// initial movement direction.
/// @param {Function} state		The function to use for this entity's initial state.
initialize = function(_state){
	__initialize(_state);
	entity_set_sprite(spr_ripper, -1);
	create_general_collider();
	
	// Only one weakness aside from a Power Bomb, Screw Attack, or an ice-based weapon: Super Missiles.
	weaknessFlags |= ENMY_SUPMISSILE_WEAK | ENMY_POWBOMB_WEAK | ENMY_SCREWATK_WEAK | ENMY_FREEZE_WEAK;
	
	// Set the rates for item drops if the Ripper is defeated by Samus here.
	dropChances[ENMY_SMENERGY_DROP]		= 0;
	dropChances[ENMY_LGENERGY_DROP]		= 30;
	dropChances[ENMY_SMMISSILE_DROP]	= 0;
	dropChances[ENMY_LGMISSILE_DROP]	= 30;
	dropChances[ENMY_AEION_DROP]		= 0;
	dropChances[ENMY_POWBOMB_DROP]		= 20;
	
	// Randomly determine a starting direction: left (-1) or right (+1); flipping the Ripper's facing direction 
	// if the chosen starting direction is to the left.
	movement = choose(1, -1);
	if (movement == -1){ // 
		lightOffsetX   *= -1;
		imageIndex		= 1;
	}
}

#endregion

#region State function initialization

/// @description The Ripper's default state. All it will do is bounce back and forth between two walls; one
/// to its left and one to its right; flipping to the opposite direction on contact with each.
state_default = function(){
	var _deltaTime = DELTA_TIME;
	hspd += movement * hAccel * _deltaTime;		// Update horizontal velocity.
	if (hspd > maxHspd || hspd < -maxHspd) 
		hspd = maxHspd * movement;
	
	var _deltaHspd	= hspd * _deltaTime;						// Remove decimal values from velocity.
	var _signHspd	= sign(_deltaHspd);
	_deltaHspd	   += hspdFraction;
	hspdFraction	= _deltaHspd - (floor(abs(_deltaHspd)) * _signHspd);
	_deltaHspd	   -= hspdFraction;
	
	if (place_meeting(x + _deltaHspd, y, par_collider)){	// Handling collision.
		while(!place_meeting(x + _signHspd, y, par_collider)) {x += _signHspd;}
		lightOffsetX   *= -1;	// Flip eye light's position
		movement	   *= -1;	// Flip movement direction
		hspd			= 0.0;
		imageIndex++;
		return;
	}
	x += _deltaHspd;
}

#endregion

// Once the create event has executed, initialize the Ripper by setting it to its default state function.
initialize(state_default);