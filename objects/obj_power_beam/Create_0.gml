#region Macro value initialization

// The positions for the bit flags that when toggled will determine if the beam is the upper, lower, or center
// projectile of the three that exist for the split power beam.
#macro	UPPER_POWER_BEAM		12
#macro	LOWER_POWER_BEAM		13

// Condenses the code required to check if the current instance of the beam projectile is the upper (Moves away
// from the center beam in negative values) or the lower (Moves away in positive values) of the three instances.
#macro	IS_UPPER_POWER_BEAM		(stateFlags & (1 << UPPER_POWER_BEAM))
#macro	IS_LOWER_POWER_BEAM		(stateFlags & (1 << LOWER_POWER_BEAM))

// Determines how fast and for how long the upper and lower power beam projectils will split away from the 
// center one whenever Samus's arm cannon is fired while having the beam splitter item and this beam active.
#macro	SPLIT_MOVEMENT_SPEED	7.5
#macro	SPLIT_BEAM_OFFSET		12
#macro	SPLIT_CHARGE_OFFSET		18

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the damage of the power beam. All other damage values will be based on whatever this beam's non-charged
// damage is.
damage = 1;
// Set the maximum horizontal and vertical movement speeds for all power beam instances (These values can be
// surpassed by the initial spread movement of any split beam variants).
maxHspd = 10;
maxVspd = 10;

#endregion

#region Unique variable initialization

// Keeps track of the initial position of the beam that will be used to see how far the upper and lower beams
// have split from the center one after being fired. Once the offset threshold has been passed, the beams will
// stop splitting away and all three will move parallel until they are each destroyed.
startOffset = 0;

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
___initialize = initialize;
/// @description 
/// @param {Function}	state			The state to initially use for the projectile in question. 
/// @param {Real}		x				Samus's horizontal position in the room.
/// @param {Real}		y				Samus's vertical position in the room.
/// @param {Real}		playerFlags
/// @param {Real}		flags
initialize = function(_state, _x, _y, _playerFlags, _flags){
	___initialize(_state, _x, _y, _playerFlags, _flags); // Calls initialize function found in "par_player_projectile".
	entity_set_sprite(PROJ_IS_CHARGED ? spr_power_beam_charged : spr_power_beam, -1);
	stateFlags |= PROJ_POWBEAM;
	
	// 
	if (audio_is_playing(snd_powerbeam))
		audio_stop_sound(snd_powerbeam);
	audio_play_sound(snd_powerbeam, 0, false, 0.3);
	
	// Determine the velocity of the beam in four base directions by default (Right, left, up, and down).
	if (PROJ_MOVING_HORIZONTAL)		{hspd = (image_xscale == -1)	? -maxHspd : maxHspd;}
	else if (PROJ_MOVING_VERTICAL)	{vspd = (image_angle == 90)		? -maxVspd : maxVspd;}
	
	// Determine the brightness, color, and size of the light produced by the power beam bullet; determined
	// by if the beam is charged or not charged prior to being fired.
	if (PROJ_IS_CHARGED) {object_add_light_component(x, y, 0, 0, 50, HEX_LIGHT_YELLOW, 0.9);}
	else				 {object_add_light_component(x, y, 0, 0, 32, HEX_YELLOW, 0.7);}
	
	// Determine the split beam velocities that will offset the upper and lower beams properly in order to 
	// create the effect required for the power beam's beam splitter effect.
	if (PROJ_MOVING_VERTICAL){
		startOffset = y; // Start offset is y since the beams will split off on that axis.
		
		// Upper beam will be on top of the center beam regardless of the beam being shot to the left or the
		// right; lower beam will be on the bottom of the center beam for the same reason as the upper beam.
		if (IS_UPPER_POWER_BEAM)		{vspd = -SPLIT_MOVEMENT_SPEED;}
		else if (IS_LOWER_POWER_BEAM)	{vspd = SPLIT_MOVEMENT_SPEED;}
	} else if (PROJ_MOVING_VERTICAL){
		startOffset = x; // Start offset is x since the beams will split off on that axis.
		
		// Upper beam will be to the left of the center beam regardless of the beam being fired up or down;
		// lower beam will be to the right of the center beam for the same reason as the upper beam.
		if (IS_UPPER_POWER_BEAM)		{hspd = -SPLIT_MOVEMENT_SPEED;}
		else if (IS_LOWER_POWER_BEAM)	{hspd = SPLIT_MOVEMENT_SPEED;}
	}
}

#endregion

#region State functions

/// @description The power beam's default state, which will process its movement for the frame, and check 
/// for possible collisions with any destructible objects in the current room.
state_default = function(){
	apply_frame_movement(projectile_world_collision);
}

/// @description The state given to the inner and outer power beams that only exist when the power beam is
/// fired after acquiring the split beam item.
state_beam_splitter = function(){
	// Continue moving the upper and lower power bomb bullets until they have hit their respective offset 
	// limit (The offsets are increased when the power beam is charged prior to firing). Once they've hit
	// their said limit, the split beam will be switched to its default state.
	var _offsetLimit = PROJ_IS_CHARGED ? SPLIT_CHARGE_OFFSET : SPLIT_BEAM_OFFSET;
	if (PROJ_MOVING_HORIZONTAL && abs(y - startOffset) >= _offsetLimit){
		object_set_next_state(state_default);
		y = startOffset + (_offsetLimit * sign(vspd));
		vspdFraction = 0;
		vspd = 0;
		return; // State has changed; exit the function early.
	} else if (PROJ_MOVING_VERTICAL && abs(x - startOffset) >= _offsetLimit){
		object_set_next_state(state_default);
		x = startOffset + (_offsetLimit * sign(hspd));
		hspdFraction = 0;
		hspd = 0;
		return; // State has changed; exit the function early.
	}
	
	// Like the default state, the frame movement function is called, which handles collision with the
	// world along with doors, destructibles, and anything else involving the game's environment.
	apply_frame_movement(projectile_world_collision);
}

#endregion