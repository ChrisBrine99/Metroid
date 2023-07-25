#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();

// Default values for the drop's sprite, which allows the rendering of sprites should a child object have a
// sprite assigned to it; looping whatever its animation may be. The "sprite_index" is set to "NO_SPRITE" to
// prevent the entity rendering from occurring.
stateFlags	   |= (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION);
sprite_index	= NO_SPRITE;
visible			= true;

#endregion

#region Unique variable initialzation

// Stores the base size and strength of the ambient light source that is tied to the object. Allows the flashing
// effect to return to those original values after being changed by the "bright" iteration of the flash.
baseRadius		= 0.0;
baseStrength	= 0.0;

#endregion

#region Utility function initialization

/// @description Default function for item drop collection. It will simply destroy the item drop without doing
/// anything else, as the functionality of the item drop is determined by the child object itself.
item_drop_collect_self = function() {
	stateFlags |= (1 << DESTROYED);
}

#endregion