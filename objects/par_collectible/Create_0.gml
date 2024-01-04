#region Macros utilized by all collectibles

// ------------------------------------------------------------------------------------------------------- //
// 
// ------------------------------------------------------------------------------------------------------- //

#macro	CLCT_SHOW_ITEM_INFO		0x00400000
// NOTE -- Bits 0x00800000 and greater are already in use by default static entity substate flags.

// ------------------------------------------------------------------------------------------------------- //
//	Internal ID values for each item that corresponds to where its name and description can be found	   //
//	within the global ds_map that stores item information.												   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ID_MORPH_BALL			0x01
#macro	ID_SPRING_BALL			0x02
#macro	ID_SPIDER_BALL			0x03
#macro	ID_VARIA_SUIT			0x04
#macro	ID_GRAVITY_SUIT			0x05
#macro	ID_HIGH_JUMP_BOOTS		0x06
#macro	ID_SPACE_JUMP			0x07
#macro	ID_SCREW_ATTACK			0x08
#macro	ID_ICE_BEAM				0x09
#macro	ID_WAVE_BEAM			0x0A
#macro	ID_PLASMA_BEAM			0x0B
#macro	ID_CHARGE_BEAM			0x0C
#macro	ID_MISSILE_LAUNCHER		0x0D
#macro	ID_SUPER_MISSILES		0x0E
#macro	ID_ICE_MISSILES			0x0F
#macro	ID_SHOCK_MISSILES		0x10
#macro	ID_MISSILE_TANK_SMALL	0x11
#macro	ID_MISSILE_TANK_LARGE	0x12
#macro	ID_ENERGY_TANK			0x13
#macro	ID_ENERGY_TANK_PIECE	0x14
#macro	ID_RESERVE_TANK			0x15
#macro	ID_POWER_BOMB_TANK		0x16
#macro	ID_BOMBS				0x17
#macro	ID_POWER_BOMBS			0x18
#macro	ID_PHASE_SHIFT			0x19
#macro	ID_ENERGY_SHIELD		0x1A
#macro	ID_SCAN_PULSE			0x1B
#macro	ID_LOCKON_MISSILES		0x1C
#macro	ID_BEAM_SPLITTER		0x1D
#macro	ID_PULSE_BOMBS			0x1E

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the collectibles up so that can draw their sprites to the screen for the player to see. Reset the value
// within "sprite_index" to its default so the function "entity_set_sprite" can be properly used to initialize
// the sprite within code.
stateFlags	   |= ENTT_DRAW_SELF | ENTT_LOOP_ANIM;
sprite_index	= NO_SPRITE;
visible			= true;

#endregion

#region Unique variable initialization

// 
flagBit = EVENT_FLAG_INVALID;
itemID = 0;

// Keeps track of the destructible object that is nearest to the collectible. If that desctructible
// is on top of the item, it will be set to invisible until the destructible above it has been
// destroyed.
destructibleID = noone;

// Stores the base size and strength of the ambient light source that is tied to the object. Allows the flashing
// effect to return to those original values after being changed by the "bright" iteration of the flash.
baseRadius		= 0.0;
baseStrength	= 0.0;

// Determines the fanfare that is played upon collection of the item. This can be changed from the default to
// whatever the item requires (Ex. shorter fanfares for tank pickups, etc.) for its collection music.
fanfare		= mus_item_found;

#endregion

#region Collection effect function initialization

/// @description 
collectible_apply_effects = function() {}

#endregion