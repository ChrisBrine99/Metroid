#region Macros that are useful/related to obj_sm_energy_drop

// ------------------------------------------------------------------------------------------------------- //
//	A macro for determining the lifespan of the small energy drop in "frames per second". On top of that,  //
//	there is another other macro for the amount of energy restored for Samus upon collection of the drop.  //
// ------------------------------------------------------------------------------------------------------- //

#macro	SM_ENERGY_LIFESPAN			900
#macro	SM_ENERGY_RESTORATION		10

// ------------------------------------------------------------------------------------------------------- //
//	Two macros for the small energy drop's ambient light source characteristics; the first being the size  //
//	of the light and the second being the intensity/brightness of the light that is cast.				   //
// ------------------------------------------------------------------------------------------------------- //

#macro	SM_ENERGY_BASE_RADIUS		16.0
#macro	SM_ENERGY_BASE_STRENGTH		0.8

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event is called by GameMaker.
event_inherited();
// Set the sprite to the small energy drop, and make its collision mask empty so the player can walk through it.
// Also, create a small purple ambient light source for the energy drop to cast in the world.
entity_set_sprite(spr_sm_energy_drop, spr_empty_mask);
object_add_light_component(x, y, 0, 0, SM_ENERGY_BASE_RADIUS, HEX_LIGHT_PURPLE, SM_ENERGY_BASE_STRENGTH);

// Store the base radius and strength of the light source as the values used in the light component's creation.
baseRadius		= SM_ENERGY_BASE_RADIUS;
baseStrength	= SM_ENERGY_BASE_STRENGTH;

// Make the energy drop last 15 seconds before despawning as 60 units = 1 real-world second.
hitpoints		= SM_ENERGY_LIFESPAN;
maxHitpoints	= (hitpoints * 0.25);

#endregion

#region Utility function initializations

/// @description An overridden version of the collection function for the item drop. It will give Samus 10 
/// points of energy upon collection and then destroy itself.
item_drop_collect_self = function(){
	with(PLAYER) {update_hitpoints(SM_ENERGY_RESTORATION);}
	play_sound_effect(snd_energy_pickup, 0, false, true, SND_TYPE_GENERAL, ITMDRP_COLLECT_VOLUME);
	stateFlags |= ENTT_DESTROYED;
}

#endregion