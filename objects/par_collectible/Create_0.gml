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
stateFlags	   |= (1 << DRAW_SPRITE) | (1 << LOOP_ANIMATION);
sprite_index	= NO_SPRITE;
visible			= true;

#endregion

#region Unique variable initialization

// The most important part of a collectible object, which will store the ID for the bit that this collectible
// is tied to within the whole of the event flag buffer. If its value is set to 1, this item will no longer
// exist. Otherwise, it will be available for the player to collect.
flagID = 0;

// Contains the name of the collectible item, as well as a description that describes the usage
// and functionality of what was just collected (There are some exception to this normal item
// collection screen showing up).
collectibleName = "";
collectibleInfo = "";

// Keeps track of the destructible object that is nearest to the collectible. If that desctructible
// is on top of the item, it will be set to invisible until the destructible above it has been
// destroyed.
destructibleID = noone;

// Stores the base size and strength of the ambient light source that is tied to the object. Allows the flashing
// effect to return to those original values after being changed by the "bright" iteration of the flash.
baseRadius		= 0.0;
baseStrength	= 0.0;

#endregion

#region Default collection function initialization

/// @description A collectible object's default collection function, which create the screen that will display
/// the item's name and its information onto the screen for the player to read; only allowing that menu to
/// close once the collection theme being completed. Sets the event flag tied to the object. A collectible
/// can override this function to have its own unique effects outside of the general tasks performed here.
collectible_collect_self = function(){
	// Copy the data that tells the collection screen what item this is (name), its functionality (info)
	// and the value that enables the use of the item (flag) after the collection screen is closed.
	var _name = collectibleName;
	var _info = collectibleInfo;
	var _flag = flagID;
	
	// Create the instance for the "menu" that displays the item's name and functionality to the player.
	// Apply a simple fade-in animation that ends with the menu being assigned its default state. Copy
	// over the item information; the being automatically by the "set_item_data" function call.
	var _menu = instance_create_menu_struct(obj_item_collection_screen);
	with(_menu){
		menu_set_next_state(state_animation_alpha, [1.0, 0.1, state_default]);
		set_item_data(_name, _info, _flag, camera_get_view_width(CAMERA.camera) - 20);
		hudAlphaTarget = GAME_HUD.alphaTarget;
		GAME_HUD.alphaTarget = 0.0;
	}
	
	// Triggers the collectible to delete itself once it's collected by the player. Its visibility is
	// set to false to prevent the object from being drawn after it's technically been "destroyed".
	stateFlags |= (1 << DESTROYED);
	visible = false;
	
	// 
	var _camera = CAMERA.camera;
	var _cellX = floor(x / camera_get_view_width(_camera));
	var _cellY = floor(y / camera_get_view_height(_camera));
	with(MAP_MANAGER){
		_cellX += rOriginX;	// Offset based on room's current origin on the map.
		_cellY += rOriginY;
		if (_cellX < 0 || _cellX >= MAP_GRID_WIDTH || _cellY < 0 || _cellY >= MAP_GRID_HEIGHT) {return;}
		with(cells[# _cellX, _cellY]) {icon = ICON_ITEM_COLLECTED;}
	}
}

#endregion