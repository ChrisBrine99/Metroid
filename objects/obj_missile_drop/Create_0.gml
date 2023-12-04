#region Macros that are useful/related to obj_missile_drop

// ------------------------------------------------------------------------------------------------------- //
//	A macro for determining the lifespan of the missile ammunition in "frames per second". On top of that, //
//	there is another other macro for the amount of energy restored for Samus upon collection of the ammo.  //
// ------------------------------------------------------------------------------------------------------- //

#macro	MISSILE_DROP_LIFESPAN		600
#macro	MISSILE_DROP_RESTORATION	5

// ------------------------------------------------------------------------------------------------------- //
//	Two macros for the missile drop's ambient light source characteristics; the first being the size of	   //
//	the light and the second being the intensity/brightness of the light that is cast.					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	MISSILE_DROP_BASE_RADIUS	14.0
#macro	MISSILE_DROP_BASE_STRENGTH	0.8

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event is called by GameMaker.
event_inherited();
// Set the sprite to the missile ammo drop, and make its collision mask empty so the player can walk through it.
// Also, create a small purple ambient light source for the ammunition to cast in the world.
entity_set_sprite(spr_missile_drop, spr_empty_mask);
object_add_light_component(x, y, 0, 0, MISSILE_DROP_BASE_RADIUS, HEX_WHITE, MISSILE_DROP_BASE_STRENGTH);

// Store the base radius and strength of the light source as the values used in the light component's creation.
baseRadius		= MISSILE_DROP_BASE_RADIUS;
baseStrength	= 0.8;

// Make the energy drop last 10 seconds before despawning as 60 units = 1 real-world second.
hitpoints		= MISSILE_DROP_LIFESPAN;
maxHitpoints	= (hitpoints * 0.25);

#endregion

#region Utility function initialization

/// @description An overridden version of the collection function for the item drop. It will give Samus 5 
/// missiles upon collection; deleting itself right after that.
item_drop_collect_self = function() {
	with(PLAYER){
		numMissiles += MISSILE_DROP_RESTORATION;
		if (numMissiles > maxMissiles) 
			numMissiles = maxMissiles;
	}
	play_sound_effect(snd_missile_pickup, 0, false, true, ITMDRP_COLLECT_VOLUME);
	stateFlags |= ENTT_DESTROYED;
}

#endregion