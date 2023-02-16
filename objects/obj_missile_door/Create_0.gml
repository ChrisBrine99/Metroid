#region Door light color macro

#macro	MISSILE_LIGHT_COLOR		HEX_LIGHT_RED

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Alter the ambient light source to match the missile lock's color scheme, while preserving its size and strength.
// The door sprite will be the general one due to the fact that the missile "door" is an overlay over said door.
lightComponent.set_properties(ACTIVE_LIGHT_RADIUS, MISSILE_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
entity_set_sprite(spr_general_door, -1, 0, 0);

#endregion