#region Macros that are useful/related to par_enemy and its children

// A macro for determining the lifespan of the missile ammunition in "frames per second". On top of that, there
// is another other macro for the amount of energy restored for Samus upon collection of the missile ammo.
#macro	AEION_DROP_LIFESPAN			750
#macro	AEION_DROP_RESTORATION		50

// Two macros for the missile drop's ambient light source characteristics; the first being the size of the
// light and the second being the intensity/brightness of the light that is cast.
#macro	AEION_DROP_BASE_RADIUS		16.0
#macro	AEION_DROP_BASE_STRENGTH	0.7

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event is called by GameMaker.
event_inherited();
// Set the sprite to the missile ammo drop, and make its collision mask empty so the player can walk through it.
// Also, create a small purple ambient light source for the ammunition to cast in the world.
entity_set_sprite(spr_aeion_drop, spr_empty_mask);
object_add_light_component(x, y, 0, 0, AEION_DROP_BASE_RADIUS, HEX_WHITE, AEION_DROP_BASE_STRENGTH);

// Store the base radius and strength of the light source as the values used in the light component's creation.
baseRadius		= AEION_DROP_BASE_RADIUS;
baseStrength	= 0.8;

// Make the energy drop last 10 seconds before despawning as 60 units = 1 real-world second.
hitpoints		= AEION_DROP_LIFESPAN;
maxHitpoints	= (hitpoints * 0.25);

#endregion

#region Utility function initialization

/// @description An overridden version of the collection function for the item drop. It will give Samus 25 
/// aeion energy points upon collection; deleting itself right after that.
item_drop_collect_self = function() {
	with(PLAYER){
		curAeion += AEION_DROP_RESTORATION;
		if (curAeion > maxAeion) {curAeion = maxAeion;}
	}
	stateFlags |= (1 << DESTROYED);
}

#endregion