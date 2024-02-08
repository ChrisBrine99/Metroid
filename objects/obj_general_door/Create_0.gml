#region Door light characteristic macros

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	DOOR_CLOSING			0x00000001
#macro	DOOR_OPENED				0x00000002

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	DOOR_IS_OPENED			(stateFlags & DOOR_OPENED)
#macro	DOOR_IS_CLOSING			(stateFlags & DOOR_CLOSING)

// ------------------------------------------------------------------------------------------------------- //
//	
// ------------------------------------------------------------------------------------------------------- //

#macro	DOOR_OPEN_ANIM_SPEED	0.8

// ------------------------------------------------------------------------------------------------------- //
//	Macros that are used by all door types; regardless of their color. No door is bright or dimmer than	   //
//	another and no door emits a greater or smaller radius of light compared to another.					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LGHT_ACTIVE_RADIUS		64
#macro	LGHT_ACTIVE_STRENGTH	0.7

// ------------------------------------------------------------------------------------------------------- //
//	Stores the percentage value of the door's opening and closing sound effect volumes relative to the	   //
//	current value set for sound effect in the game's options.											   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DOOR_VOLUME				0.75

// ------------------------------------------------------------------------------------------------------- //
//	Determines how the door opening/closing sound effects will be heard by the player. The first value is  //
//	the beginning of the volume falloff, the second is the maximum audible distance, and the final value   //
//	is how fast the audio falls off in volume.															   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DOOR_FALLOFF_REFDIST	100.0
#macro	DOOR_FALLOFF_MAXDIST	250.0
#macro	DOOR_FALLOFF_FACTOR		5.0

#endregion

#region	Editing inherited variables

// Ensures all variables that are created within the parent object's create event are also initialized through
// this event, which overrides the former's create event outright.
event_inherited();
// 
object_add_light_component(x, y, 0, 0, LGHT_ACTIVE_RADIUS, HEX_LIGHT_BLUE, LGHT_ACTIVE_STRENGTH);
object_add_audio_component(x, y, 0, 0, DOOR_FALLOFF_REFDIST, DOOR_FALLOFF_MAXDIST, DOOR_FALLOFF_FACTOR);
// 
entity_set_sprite(spr_general_door, -1, 0, 0);
stateFlags |= ENTT_DRAW_SELF;
visible = true;

#endregion

#region Unique variable initialization

// Used for special doors: missile, power bombs, and super missile doors. It will store the ID that is checked
// when the door object is loaded into memory. If that flag is set already, the door will be replaced by a
// general door instead of what it originally was.
flagID = EVENT_FLAG_INVALID;

#endregion