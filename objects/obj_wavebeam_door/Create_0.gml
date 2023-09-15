#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Alter the ambient light source to match the wave door's color scheme, while preserving its size and strength.
// Also swap the sprite to the one that represents the wave door instead of the default general door.
lightComponent.set_properties(LGHT_ACTIVE_RADIUS, HEX_LIGHT_PURPLE, LGHT_ACTIVE_STRENGTH);
entity_set_sprite(spr_wavebeam_door, -1, 0, 0);

#endregion