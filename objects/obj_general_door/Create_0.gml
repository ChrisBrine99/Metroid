#region Door light characteristic macros

// Macros that are used by all door types; regardless of their color. No door is bright or dimmer than another
// and no door emits a greater or smaller radius of light compared to another.
#macro	ACTIVE_LIGHT_RADIUS		64
#macro	ACTIVE_LIGHT_STRENGTH	0.7

// The color for this general doorway. Each door will have its own macro to represent its color.
#macro	GENERAL_LIGHT_COLOR		HEX_LIGHT_BLUE

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// Create the light source that will be used by this general doorway and all of its children; the position, size
// and strength of the light is consistent between all door types, but the colors are updated on a per-door
// basis. The visibilty flag and ability for the sprite to render to the screen are toggled.
object_add_light_component(x, y, 0, 0, ACTIVE_LIGHT_RADIUS, GENERAL_LIGHT_COLOR, ACTIVE_LIGHT_STRENGTH);
entity_set_sprite(spr_general_door, -1, 0, 0);
stateFlags |= (1 << DRAW_SPRITE);
visible = true;

#endregion

#region Unique variable initialization

// Used for special doors: missile, power bombs, and super missile doors. It will store the ID that is checked
// when the door object is loaded into memory. If that flag is set already, the door will be replaced by a
// general door instead of what it originally was.
flagID = EVENT_FLAG_INVALID;

#endregion