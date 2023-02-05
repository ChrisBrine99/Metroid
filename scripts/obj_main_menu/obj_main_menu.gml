/// @description

#region Initializing any macros that are useful/related to obj_main_menu
#endregion

#region Initializing enumerators that are useful/related to obj_main_menu
#endregion

#region Initializing any globals that are useful/related to obj_main_menu
#endregion

#region The main object code for obj_main_menu

function obj_main_menu() : par_menu() constructor{
	// Much like Game Maker's own object_index variable, this will store the unique ID value provided to this
	// object by Game Maker during runtime; in order to easily use it within the menu management system.
	object_index = obj_main_menu;
	
	// 
	drawFunction = NO_STATE;
	
	// 
	startPromptAlpha = 1;
	startPromptAlphaTarget = 1;
	
	/// @description 
	initialize = function(){
		// 
		isMenuActive = true;
		object_set_next_state(state_title_screen);
		drawFunction = method_get_index(draw_title_screen);
		
		// 
		menuWidth = 1;
		numVisibleColumns = 1;
		numVisibleRows = 6;
		
		// 
		title = "Scary Things in Dirty Rooms";
		
		//
		add_option("New Game", true);
		add_option("Load Game", false);
		add_option("Statistics", true);
		add_option("Achievements", true);
		add_option("Settings", true);
		add_option("Exit", true);
		
		//
		var _xx, _yy;
		_xx = CAM_HALF_WIDTH;
		_yy = CAM_HEIGHT - 30;
		add_option_info(_xx, _yy, "Begin a new venture into the horros of the mind...", "");
		add_option_info(_xx, _yy, "Continue where you left off from an available save file.", "There's no save data to load from.");
		add_option_info(_xx, _yy, "See all of the globally tracked data since you began playing.", "");
		add_option_info(_xx, _yy, "View achievements and the rewards they unlock once completed.", "");
		add_option_info(_xx, _yy, "Adjust options relating to the game's graphics, audio, and so on.", "");
		add_option_info(_xx, _yy, "Close the game and exit to your desktop.", "");
		
		// 
		control_info_add_displayed_icon(INPUT_MENU_UP, "", ALIGNMENT_LEFT);
		control_info_add_displayed_icon(INPUT_MENU_DOWN, "Choose Option", ALIGNMENT_LEFT);
		control_info_add_displayed_icon(INPUT_SELECT, "Select", ALIGNMENT_RIGHT, true);
		
		// 
		set_animation_state(menu_animation_alpha, [1, 0.1]);
	}
	
	/// @description 
	draw_gui = function(){
		if (drawFunction != NO_STATE) {drawFunction();}
	}
	
	/// @description 
	state_title_screen = function(){
		// 
		if (startPromptAlphaTarget == 0 && startPromptAlpha == 0)		{startPromptAlphaTarget = 1;}
		else if (startPromptAlphaTarget == 1 && startPromptAlpha == 1)	{startPromptAlphaTarget = 0;}
		startPromptAlpha = value_set_linear(startPromptAlpha, startPromptAlphaTarget, 0.025);
		
		// 
		if ((!global.gamepad.isActive && keyboard_check_pressed(vk_anykey)) || gamepad_any_button(global.gamepad.deviceID, false)){
			selOption = -1; // Fixes a bug if the player presses the "select" key to continue forward.
			set_animation_state(
				menu_animation_alpha,	// Animation function and its arguments
				[0, 0.05], 
				post_animation_default,	// Animation completion function and its arguments
				[state_default, draw_default]
			);
		}
	}
	
	/// @description 
	state_default = function(){
		// 
		if (inputReturn){
			startPromptAlpha = 1;
			set_animation_state(
				menu_animation_alpha,
				[0, 0.05],
				post_animation_default,
				[state_title_screen, draw_title_screen]
			);
		}
	}
	
	/// @description 
	draw_title_screen = function(){
		// 
		var _halfWidth = CAM_HALF_WIDTH;
		
		// 
		shader_set_outline(RGB_DARK_RED, font_gui_large);
		
		// 
		draw_title(_halfWidth, 25, font_gui_large, fa_center, fa_top, alpha, HEX_RED, RGB_DARK_RED);
		
		// 
		outline_set_font(font_gui_small);
		draw_set_halign(fa_center);
		draw_text_outline(_halfWidth, CAM_HEIGHT - 12, "Copyright Christopher Brine, 2022", HEX_WHITE, RGB_GRAY, alpha);
		
		// 
		if (!global.gamepad.isActive) {draw_text_outline(_halfWidth, CAM_HEIGHT - 45, "Press Any Key", HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, alpha * startPromptAlpha);}
		else {draw_text_outline(_halfWidth, CAM_HEIGHT - 45, "Press Any Button", HEX_LIGHT_YELLOW, RGB_DARK_YELLOW, alpha * startPromptAlpha);}
		draw_set_halign(fa_left);
		
		// 
		shader_reset();
	}
	
	/// @description 
	draw_default = function(){
		// 
		var _alpha, _selOption;
		_alpha = alpha;
		_selOption = selOption;
		with(CONTROL_INFO){
			if (_selOption == -1) {alpha = _alpha;}
		}
		
		// 
		
		
		// 
		shader_set_outline(RGB_GRAY, font_gui_medium);
		draw_options(CAM_HALF_WIDTH, 50, 0, 14, font_gui_medium, fa_center, fa_middle, _alpha);
		draw_option_info(curOption, font_gui_small, fa_center, fa_top, _alpha);
		shader_reset();
	}
	
	/// @description 
	/// @param state
	/// @param drawFunction
	post_animation_default = function(_state, _drawFunction){
		object_set_next_state(_state);
		set_animation_state(menu_animation_alpha, [1, 0.05]);
		drawFunction = _drawFunction;
	}
}

#endregion

#region Global functions related to obj_main_menu
#endregion