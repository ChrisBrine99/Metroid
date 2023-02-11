#region Macro value initialization
#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Set the damage of the power beam. All other damage values will be based on whatever this beam's non-charged
// damage is.
damage = 4;
// Set the maximum horizontal and vertical movement speeds for all power beam instances (These values can be
// surpassed by the initial spread movement of any split beam variants).
maxHspd = 7.5;
maxVspd = 7.5;

#endregion

#region Unique variable initialization

// 
angleTimer = 0;

#endregion

#region Object initialization function

// Store the pointer for the inherited initialization function within another variable. Then, that variable is
// used to call the parent function within this child object's own initialization function.
___initialize = initialize;
/// @description 
/// @param {Function}	state			The state to initially use for the projectile in question. 
/// @param {Real}		x				Samus's horizontal position in the room.
/// @param {Real}		y				Samus's vertical position in the room.
/// @param {Real}		imageXScale		Samus's current facing direction (1 == right, -1 == left).
/// @param {Bool}		isCharged		Determines if the beam is charged or not.
initialize = function(_state, _x, _y, _imageXScale, _isCharged){
	___initialize(_state, _x, _y, _imageXScale, _isCharged); // Calls initialize function found in "par_player_projectile".
	entity_set_sprite(_isCharged ? spr_ice_beam_charged : spr_ice_beam_bullet, -1);
	stateFlags |= (1 << TYPE_ICE_BEAM);
	
	// Determine the brightness, color, and size of the light produced by the power beam bullet; determined
	// by if the beam is charged or not charged prior to being fired.
	if (_isCharged) {object_add_light_component(x, y, 0, 0, 48, HEX_WHITE, 1);}
	else			{object_add_light_component(x, y, 0, 0, 26, HEX_WHITE, 0.7);}
	
	// Randomize the starting angle for the sprite so each ice beam bullet looks different from the last.
	image_angle = random(360);
}

#endregion

#region State functions

/// @description The ice beam's default state, which will process its movement for the frame, and check 
/// for possible collisions with any destructible objects in the current room.
state_default = function(){
	apply_frame_movement(projectile_world_collision);
	collision_destructible_objects();
	
	// 
	angleTimer += DELTA_TIME * 8;
	if (angleTimer >= 1){
		image_angle += 45;
		angleTimer--;
	}
}

#endregion