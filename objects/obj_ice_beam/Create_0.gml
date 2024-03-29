#region Macro value initialization

// ------------------------------------------------------------------------------------------------------- //
//	Stores the volume of the Ice Beam's normal and charged shot sound effects relative to the current	   //
//	percentage value set for the volume of general sound effects by the player.							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ICEBEAM_VOLUME			0.3

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the damage of the ice beam, which is 4.0x as strong as the standard power beam. All other damage values 
// will be based on whatever this beam's non-charged damage is.
damage = 4;
// Set the maximum horizontal and vertical movement speeds for all power beam instances (These values can be
// surpassed by the initial spread movement of any split beam variants).
maxHspd = 7.5;
maxVspd = 7.5;

#endregion

#region Unique variable initialization

// Stores the amount of time that has passed since the ice beam has shifted its angle, which occurs in 45 degree
// intervals to fake an 8-frame animation.
angleTimer = 0.0;

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
	entity_set_sprite(PROJ_IS_CHARGED ? spr_ice_beam_charged : spr_ice_beam_bullet, -1);
	object_add_light_component(x, y, 0, 0, 32.0, HEX_VERY_LIGHT_BLUE, 0.7);
	stateFlags |= PROJ_ICEBEAM;
	
	// Determine the velocity of the beam in four base directions by default (Right, left, up, and down).
	if (PROJ_MOVING_HORIZONTAL)		{hspd = (image_xscale == -1) ?	-maxHspd : maxHspd;}
	else if (PROJ_MOVING_VERTICAL)	{vspd = (image_angle == 90) ?	-maxVspd : maxVspd;}
	
	// Determine what characteristics to apply to the power beam bullet based on if it was charged or not.
	// The light component and sound effect are altered relative to the charged state of the projectile.
	if (PROJ_IS_CHARGED){
		lightComponent.set_properties(48.0, HEX_VERY_LIGHT_BLUE, 1.0);
		play_sound_effect(snd_icebeam, 0, false, true, SND_TYPE_GENERAL, ICEBEAM_VOLUME); // TODO: change to charged Ice Beam sound.
	} else{
		play_sound_effect(snd_icebeam, 0, false, true, SND_TYPE_GENERAL, ICEBEAM_VOLUME);
	}
	
	// Randomize the starting angle for the sprite so each ice beam bullet looks different from the last.
	// These angles are locked to 45 degree intervals instead of allowing all possible angles to mimick an
	// eight-frame spinning animation for the beam.
	image_angle = 45.0 * irandom(8);
}

#endregion

#region State functions

/// @description The ice beam's default state, which will process its movement for the frame, and check 
/// for possible collisions with any destructible objects in the current room.
state_default = function(){
	apply_frame_movement(projectile_world_collision);
	
	// Causing the ice beam to spin; simulating an 8-frame rotation animation due to the actual angle of
	// the sprite only being updated at 45 degree intervals.
	angleTimer += 0.5 * DELTA_TIME;
	if (angleTimer >= 1.0){
		image_angle += 45.0;
		angleTimer -= 1.0;
	}
}

#endregion