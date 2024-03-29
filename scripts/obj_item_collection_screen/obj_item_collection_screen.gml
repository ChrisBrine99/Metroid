#region Initializing any macros that are useful/related to obj_item_collection_screen

// ------------------------------------------------------------------------------------------------------- //
//	Macro that stores the value representing the denominator that determines the speed that an item's	   //
//	description text types itself onto the screen. Each line uses this value as a normalization relative   //
//	to their total number of characters so all lines finish at the same time							   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ITMSCRN_TEXT_SPEED		15.0

#endregion

#region Initializing enumerators that are useful/related to obj_item_collection_screen
#endregion

#region Initializing any globals that are useful/related to obj_item_collection_screen
#endregion

#region The main object code for obj_item_collection_screen

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_item_collection_screen(_index) : par_menu(_index) constructor{
	// 
	info		= [];
	
	// Stores the total length of the "info" array and the height in pixels of a single line of text in the
	// item description font. These are both used in tandem to make the individual lines stored in array "info"
	// look like they're a single string split by newline characters.
	numLines	= 0;
	draw_set_font(font_gui_small);		// Required for accurate calculation of string height on the next line.
	strHeight	= string_height("M");
	
	// Stores the current characters of the item description text that is currently visible on the screen. The 
	// array is used to achieve the "typing" effect that's a part of the menu's opening animation.
	shownInfo	= [];
	shownName	= "";
	
	// 
	showSpeed	= [];
	showTimer	= [];
	nextChar	= [];
	
	// 
	itemInstance = noone;
	soundID		 = NO_SOUND;
	
	// Stores whatever the in-game HUD's opacity level target was prior to the item collection screen 
	// opening. It will reset the HUD's target back to this value once the menu is closed.
	hudAlphaTarget = 0.0;
	
	// Another alpha value that is unique to the "press to continue" input that onlt appears when the player 
	// can close the item collection screen by fading into with this value.
	auxAlpha = 0.0;
	
	/// @description 
	/// @param {Real}	width	
	/// @param {Real}	height	
	draw_gui = function(_width, _height){
		// 
		var _deltaTime	   = DELTA_TIME;
		var _screenCenterX = (_width >> 1);
		var _screenCenterY = (_height >> 1);
		
		// 
		var _backAlpha = alpha * 0.5;
		draw_sprite_ext(spr_rectangle, 0, 0, 0, _width, _height, 0, HEX_BLACK, _backAlpha);
		draw_sprite_ext(spr_rectangle, 0, 0, _screenCenterY - 14, _width, 13, 0, 
			HEX_VERY_DARK_BLUE, _backAlpha);
		
		// 
		if (strHeight != 0.0){
			var _rectHeight = strHeight * numLines;
			draw_sprite_ext(spr_rectangle, 0, 0, _screenCenterY + 2, _width, _rectHeight + 8, 
				0, HEX_VERY_DARK_BLUE, _backAlpha);
			draw_sprite_ext(spr_rectangle, 0, 0, _screenCenterY + 4, _width, _rectHeight + 4, 
				0, HEX_VERY_DARK_BLUE, _backAlpha);
		}
	
		// 
		shader_set_outline(font_gui_medium, RGB_DARK_GREEN);
		draw_menu_title(font_gui_medium, _screenCenterX, _screenCenterY - 14, fa_center, fa_top, 
			HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, alpha);

		// 
		outline_set_font(font_gui_small);
		draw_set_halign(fa_center);
		for (var i = 0; i < numLines; i++){
			if (shownInfo[i] != ""){ // Only display text that is actually available.
				draw_text_outline(_screenCenterX, _screenCenterY + 6 + (i * strHeight), 
					shownInfo[i], HEX_WHITE, RGB_GRAY, alpha);
			}

			// 
			showTimer[i] += showSpeed[i] * _deltaTime;
			if (showTimer[i] > 1.0){
				var _text = info[i];
				while(showTimer[i] > 1.0){ // Loop until all required characters have been added to the shown line.
					shownInfo[i] += string_char_at(_text, nextChar[i]);
					showTimer[i] -= 1.0;
					nextChar[i]++;
				}
			}
		}
		
		// 
		if (soundID == NO_SOUND){
			draw_text_outline(_screenCenterX, _height - 10, "Press [Z] to continue.", 
				HEX_WHITE, RGB_GRAY, auxAlpha * alpha);
			
			// 
			auxAlpha += _deltaTime * 0.1;
			if (auxAlpha > 1.0) {auxAlpha = 1.0;}
		}
		
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
		if (soundID == NO_SOUND && MENU_SELECT_PRESSED){
			menu_set_next_state(state_animation_alpha, [0.0, 0.1, state_destroy_menu]);
		} else if (soundID != NO_SOUND && !audio_is_playing(soundID)){
			soundID = NO_SOUND; // Allows the collection screen to be closed by user input.
		}
	}
	
	/// @description Triggers the menu to destroy itself at the end of the frame and sets the flag for
	/// the item that created the screen in the first place. On top of that, the game's HUD alpha target
	/// is reset to its value prior to this screen being opened.
	state_destroy_menu = function(){
		with(itemInstance){
			event_set_flag(flagBit, true);
			collectible_apply_effects();
			stateFlags |= ENTT_DESTROYED;
		}
		stateFlags |= MENU_DESTROYED;
		GAME_HUD.alphaTarget = hudAlphaTarget;
	}
	
	/// @description 
	/// @param {Real}	itemID		The unique ID value for the item.
	set_item_data = function(_itemID){
		// 
		var _data = ds_map_find_value(global.items, _itemID);
		if (is_undefined(_data)) {return;}
		
		// 
		title		= _data.itemName;
		info		= string_split_ext(_data.itemInfo, ["\n"], true);
		
		// 
		numLines	= array_length(info);
		shownInfo	= array_create(numLines, "");
		nextChar	= array_create(numLines, 1);
		
		// 
		showTimer	= array_create(numLines, 0.0);
		showSpeed	= array_create(numLines, 0.0);
		for (var i = 0; i < numLines; i++) 
			showSpeed[i] = string_length(info[i]) / ITMSCRN_TEXT_SPEED;
	}
}

#endregion

#region Global functions related to obj_item_collection_screen
#endregion