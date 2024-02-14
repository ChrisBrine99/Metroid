#region Macros that are useful/related to obj_lg_energy_drop


// ------------------------------------------------------------------------------------------------------- //
//	A macro for determining the lifespan of the large energy drop in "frames per second". On top of that,  //
//	there is another other macro for the amount of energy restored for Samus upon collection of the drop.  //
// ------------------------------------------------------------------------------------------------------- //

#macro	LG_ENERGY_LIFESPAN			900
#macro	LG_ENERGY_RESTORATION		30

// ------------------------------------------------------------------------------------------------------- //
//	Two macros for the large energy drop's ambient light source characteristics; the first being the size  //
//	of the light and the second being the intensity/brightness of the light that is cast.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	LG_ENERGY_BASE_RADIUS		24.0
#macro	LG_ENERGY_BASE_STRENGTH		0.8

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event is called by GameMaker.
event_inherited();
// Set the sprite to the large energy drop, and make its collision mask empty so the player can walk through it.
// Also, create a large purple ambient light source for the energy drop to cast in the world.
entity_set_sprite(spr_lg_energy_drop, spr_empty_mask);
object_add_light_component(x, y, 0, 0, LG_ENERGY_BASE_RADIUS, HEX_LIGHT_PURPLE, LG_ENERGY_BASE_STRENGTH);

// Store the base radius and strength of the light source as the values used in the light component's creation.
baseRadius		= LG_ENERGY_BASE_RADIUS;
baseStrength	= 0.8;

// Make the energy drop last 15 seconds before despawning as 60 units = 1 real-world second.
hitpoints		= LG_ENERGY_LIFESPAN;
maxHitpoints	= (hitpoints * 0.25);

#endregion

#region Utility function initialization

/// @description An overridden version of the collection function for the item drop. It will give Samus 30 
/// points of energy upon collection and then destroy itself.
item_drop_collect_self = function() {
	with(PLAYER) {update_hitpoints(LG_ENERGY_RESTORATION);}
	play_sound_effect(snd_energy_pickup, 0, false, true, SND_TYPE_GENERAL, ITMDRP_COLLECT_VOLUME);
	stateFlags |= ENTT_DESTROYED;
}

#endregion