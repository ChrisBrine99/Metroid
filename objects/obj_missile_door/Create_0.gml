#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Alter the ambient light source to match the missile lock's color scheme, while preserving its size and strength.
// The door sprite will be the general one due to the fact that the missile "door" is an overlay over said door.
lightComponent.set_properties(64, HEX_LIGHT_RED, 0.7);
entity_set_sprite(spr_general_door, -1, 0, 0);

#endregion