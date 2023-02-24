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
stateFlags = (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION);
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

// Stores the base size and strength of the ambient light source that is tied to the object. Allows the flashing
// effect to return to those original values after being changed by the "bright" iteration of the flash.
baseRadius = 0;
baseStrength = 0;

#endregion

#region Default collection function initialization

/// @description A collectible object's default collection function, which create the screen that will display
/// the item's name and its information onto the screen for the player to read; only allowing that menu to
/// close once the collection theme being completed. Sets the event flag tied to the object. A collectible
/// can override this function to have its own unique effects outside of the general tasks performed here.
collectible_collect_self = function(){
	// Copy the values stored for the colelctible's name and functionality/information into local variables
	// so they can be copied over into the menu without having to jump between the menu struct's scope and
	// the collectible's scope twice.
	var _name = collectibleName;
	var _info = collectibleInfo;
	
	// Create the instance for the "menu" that displays the item's name and functionality to the player.
	// Apply a simple fade-in animation that ends with the menu being assigned its default state. Copy
	// over the item information; the being automatically by the "set_item_data" function call.
	var _menu = instance_create_menu_struct(obj_item_collection_screen);
	with(_menu){
		menu_set_next_state(state_animation_alpha, [1, 0.1, state_default]);
		set_item_data(_name, _info, camera_get_width() - 20);
	}
	
	// Set the flag that is assigned to this collectible to true within the buffer of event flags; preventing
	// the item from respawning despite the game's rooms not being considered persistent. Flag the collectible
	// for destruction after that.
	event_set_flag(flagID, true);
	stateFlags |= (1 << DESTROYED);
	visible = false;
}

#endregion