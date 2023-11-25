#region Macros utilized by all collectibles

// ------------------------------------------------------------------------------------------------------- //
// 
// ------------------------------------------------------------------------------------------------------- //

#macro	CLCT_SHOW_ITEM_INFO		0x00400000
// NOTE -- Bits 0x00800000 and greater are already in use by default static entity substate flags.

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

// Determines the fanfare that is played upon collection of the item. This can be changed from the default to
// whatever the item requires (Ex. shorter fanfares for tank pickups, etc.) for its collection music.
fanfare		= mus_major_item_found;

#endregion

#region Default collection function initialization

/// @description The function that is called upon collecting the item. It handles the creation of the screen
/// that details what the collected item is and how it affects Samus's abilities. On top of that, the map tile
/// where the item is located within has its "empty" icon set to a "collected" icon to signify the item in that
/// tile has been collected by the player.
collectible_collect_self = function(){
	// Stores the item's name, description, and flag into local variables so they can be quickly copied over
	// to the item collection screen menu object. The collectible's unique instance ID and the sound ID for 
	// the fanfare that was played are also copied over to the menu instance.
	var _name	= collectibleName;
	var _info	= collectibleInfo;
	var _flag	= flagID;
	var _id		= id;
	var _sound	= audio_play_sound(fanfare, 0, false);
	var _menu	= instance_create_menu_struct(obj_item_collection_screen);
	with(_menu){
		menu_set_next_state(state_animation_alpha, [1.0, 0.1, state_default]);
		set_item_data(_name, _info, _flag, display_get_gui_width() - 40);
		hudAlphaTarget		 = GAME_HUD.alphaTarget;
		itemInstance		 = _id;
		soundID				 = _sound;
		GAME_HUD.alphaTarget = 0.0; // Fade HUD out until item is "collected" by the player.
	}
	
	// Finally, determine the current map tile that the item occupies within the level. Once found, the tile's
	// icon is set to the icon to signify the item has been collected by the player. It's important to note that
	// this ignores other items in the same tile, so placing multiple items per single map cell should be avoided.
	var _cellX = floor(x / display_get_gui_width());
	var _cellY = floor(y / display_get_gui_height());
	with(MAP_MANAGER){
		_cellX += rOriginX;	// Offset based on room's current origin on the map.
		_cellY += rOriginY;
		if (_cellX < 0 || _cellX >= MAP_GRID_WIDTH || _cellY < 0 || _cellY >= MAP_GRID_HEIGHT) 
			return;
		
		with(cells[# _cellX, _cellY]) {icon = ICON_ITEM_COLLECTED;}
	}
}

#endregion