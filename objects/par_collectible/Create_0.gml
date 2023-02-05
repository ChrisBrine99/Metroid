#region Macros utilized by all collectibles

// Determines how close Samus needs to be in pixels from the center of a collectible item in order for it to
// be acquired by her; granting the ability to her for that point onward.
#macro COLLECTIBLE_RADIUS		8

#endregion

#region Editing inherited variables

// Inherit the component variables that are initialized in the parent object. Otherwise, any child object will 
// cause a crash once its "cleanup" event ic called by GameMaker.
event_inherited();
// Set the collectibles up so that can draw their sprites to the screen for the player to see. Reset the value
// within "sprite_index" to its default so the function "entity_set_sprite" can be properly used to initialize
// the sprite within code.
stateFlags |= (1 << DRAW_SPRITE);
sprite_index = NO_SPRITE;
visible = true;

#endregion

#region Unique variable initialization

// The most important part of a collectible object, which will store the ID for the bit that this collectible
// is tied to within the whole of the event flag buffer. If its value is set to 1, this item will no longer
// exist. Otherwise, it will be available for the player to collect.
flagID = 0;

// 
collectibleName = "";
collectibleInfo = "";

// 
destructibleID = noone;

//
baseRadius = 0;
baseStrength = 0;

#endregion

#region Default collection function initialization

/// @description 
collectible_collect_self = function(){
	// 
	show_debug_message("Item: " + collectibleName + "\n" + collectibleInfo);
	
	// 
	event_set_flag(flagID, true);
	stateFlags |= (1 << DESTROYED);
	visible = false;
}

#endregion