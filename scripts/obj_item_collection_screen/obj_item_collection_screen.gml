#region Initializing any macros that are useful/related to obj_item_collection_screen

#macro ITEM_SCREEN_DEFAULT		obj_item_collection_screen.state_default

#endregion

#region Initializing enumerators that are useful/related to obj_item_collection_screen
#endregion

#region Initializing any globals that are useful/related to obj_item_collection_screen
#endregion

#region The main object code for obj_item_collection_screen

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_item_collection_screen(_index) : par_menu(_index) constructor{
	// 
	info			= "";
	flag			= -1;
	
	// 
	itemInstance	= noone;
	
	// Stores whatever the in-game HUD's opacity level target was prior to the item collection screen 
	// opening. It will reset the HUD's target back to this value once the menu is closed.
	hudAlphaTarget	= 0.0;
	
	/// @description 
	/// @param {Real}	width	
	/// @param {Real}	height	
	draw_gui = function(_width, _height){
		// 
		draw_sprite_ext(spr_rectangle, 0, 0, 0, _width, _height, 0, HEX_BLACK, alpha * 0.5);
		
		// 
		var _screenCenterX = (_width >> 1);
		var _screenCenterY = (_height >> 1);
		shader_set_outline(font_gui_medium, RGB_DARK_GREEN);
		draw_menu_title(font_gui_medium, _screenCenterX, _screenCenterY - 10, fa_center, fa_middle, 
			HEX_GREEN, RGB_DARK_GREEN, alpha);
		
		// 
		outline_set_font(font_gui_small);
		draw_set_halign(fa_center);
		draw_text_outline(_screenCenterX, _screenCenterY + 6, info, HEX_WHITE, RGB_GRAY, alpha);
		draw_text_outline(_screenCenterX, _height - 12, "Press [Z] to continue.", HEX_WHITE, RGB_GRAY, alpha);
		draw_set_halign(fa_left);
		
		shader_reset();
	}
	
	/// @description The default state for the item collection screen, which will poll the only valid
	/// input for the menu. It will close out the menu when that input is pressed under the proper
	/// conditions; doing nothing otherwise.
	state_default = function(){
		// Copy over the bit that may have been set by the user pressing the select input on either the 
		// keyboard or gamepad depending on what they're currently utilizing. Then, clear the "inputFlags"
		// variable for the current frame.
		prevInputFlags	= inputFlags;
		inputFlags		= 0;
		if (GAMEPAD_IS_ACTIVE){  // Getting gamepad input (Only a single check required) for the frame.
			
		} else{ // Getting keyboard input (Only a single check required) for the frame.
			if (keyboard_check(KEYCODE_SELECT))
				inputFlags = MENU_SELECT;
		}
		
		// Close out the menu once the collection theme has finished playing; fading it out until its
		// opacity reaches zero and pinging its destruction after that condition has been met.
		if (MENU_SELECT_PRESSED){
			// TODO -- Check if song has finished before allowing item collection screen to close
			menu_set_next_state(state_animation_alpha, [0.0, 0.1, state_destroy_menu]);
		}
	}
	
	/// @description Triggers the menu to destroy itself at the end of the frame and sets the flag for
	/// the item that created the screen in the first place. On top of that, the game's HUD alpha target
	/// is reset to its value prior to this screen being opened.
	state_destroy_menu = function(){
		with(itemInstance) {stateFlags |= ENTT_DESTROYED;}
		stateFlags			|= MENU_DESTROYED;
		GAME_HUD.alphaTarget = hudAlphaTarget;
		event_set_flag(flag, true);
	}
	
	/// @description 
	/// @param {String}	item		The name of the item that was collected.
	/// @param {String}	info		The text that explains what the collectible gives to Samus.
	/// @param {Real}	flag		The bit that represents this item's collected state in the code.
	/// @param {Real}	maxWidth	The maximum possible width that a single line of the info text can be.
	set_item_data = function(_item, _info, _flag, _maxWidth){
		title	= _item;
		info	= string_format_width(_info, _maxWidth, font_gui_small);
		flag	= _flag;
	}
}

#endregion

#region Global functions related to obj_item_collection_screen
#endregion