#region Macro initialization for the inactive door

// Since this door is inactive, it will be emitting a light that is much smaller and dimmer than a standard
// doorway. These macros will store those characteristic values for the radius and strength, repsectively.
#macro	INACTIVE_LIGHT_RADIUS	32
#macro	INACTIVE_LIGHT_STRENGTH	0.4

// The light that is utilized by the inactive doorway and only that doorway type.
#macro	INACTIVE_LIGHT_COLOR	HEX_LIGHT_GRAY

// 
#macro	GENERAL_DOOR			0
#macro	ICE_DOOR				1
#macro	WAVE_DOOR				2
#macro	PLASMA_DOOR				3

// 
#macro	MISSILE_DOOR			4
#macro	SUPER_MISSILE_DOOR		5
#macro	POWER_BOMB_DOOR			6

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Alter the ambient light source to match the plasma door's color scheme, while preserving its size and strength.
// Also swap the sprite to the one that represents the plasma door instead of the default general door.
lightComponent.set_properties(INACTIVE_LIGHT_RADIUS, INACTIVE_LIGHT_COLOR, INACTIVE_LIGHT_STRENGTH);
entity_set_sprite(spr_inactive_door, -1, 0, 0);

#endregion

#region Unique variable initialization

// 
activeID = EVENT_FLAG_INVALID;
trueType = GENERAL_DOOR;

#endregion

#region Object function initializations

/// @description Alters the door's sprite and ambient light characteristics to match what door it is set to
/// become once activated by a switch or event triggered by the player. It will also flip its flag (If it
/// uses one) to cause the door to remain active even after the room is unloaded and reloaded.
activate_door = function(){
	switch(trueType){
		default: // By default the inactive door will become a blue door.
		case GENERAL_DOOR:
			lightComponent.set_properties(ACTIVE_LIGHT_RADIUS, GENERAL_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
			entity_set_sprite(spr_general_door, -1, 0, 0);
			break;
		case ICE_DOOR:
			lightComponent.set_properties(ACTIVE_LIGHT_RADIUS, ICE_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
			entity_set_sprite(spr_icebeam_door, -1, 0, 0);
			break;
		case WAVE_DOOR:
			lightComponent.set_properties(ACTIVE_LIGHT_RADIUS, WAVE_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
			entity_set_sprite(spr_wavebeam_door, -1, 0, 0);
			break;
		case PLASMA_DOOR:
			lightComponent.set_properties(ACTIVE_LIGHT_RADIUS, PLASMA_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
			entity_set_sprite(spr_plasmabeam_door, -1, 0, 0);
			break;
	}
	if (activeID != EVENT_FLAG_INVALID) {event_set_flag(activeID, true);}
}

/// @desrciption Alters the door's sprite and its ambient light characteristics to match what they should be
/// whenever a door is deactivated. Flips the flag that determines if the door will remain active even after
/// the player has left the room and come back.
deactivate_door = function(){
	lightComponent.set_properties(INACTIVE_LIGHT_RADIUS, INACTIVE_LIGHT_COLOR, INACTIVE_LIGHT_STRENGTH);
	entity_set_sprite(spr_inactive_door, -1, 0, 0);
	if (activeID != EVENT_FLAG_INVALID) {event_set_flag(activeID, false);}
}

/// @description 
/// @param {Id.Instance}	projectile	The object that has collided with the door instance in question.
inactive_door_collision = function(_projectile){
	// Don't even bother processing collision if the door is still inactive.
	if (sprite_index == spr_inactive_door) {return false;}
	
	var _doorType = trueType;
	with(_projectile){
		switch(_doorType){
			default: // By default the door will be treated like a blue door.
			case GENERAL_DOOR:		return true;
			case ICE_DOOR:			return stateFlags & (1 << TYPE_ICE_BEAM);
			case WAVE_DOOR:			return stateFlags & (1 << TYPE_WAVE_BEAM);
			case PLASMA_DOOR:		return stateFlags & (1 << TYPE_PLASMA_BEAM);
		}
	}
}

#endregion