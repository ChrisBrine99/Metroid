/// @description A script file containing all the code and logic for the game's control information display.

#region Initializing any macros that are useful/related to obj_control_info

// Macros that store the values for determining how an anchor's control info elements are alignment to its
// position on the screen.
#macro	ALIGNMENT_RIGHT				1001
#macro	ALIGNMENT_LEFT				1002
#macro	ALIGNMENT_UP				1003
#macro	ALIGNMENT_DOWN				1004

// 
#macro	INPUT_GAME_RIGHT			"input_game_right"
#macro	INPUT_GAME_LEFT				"input_game_left"
#macro	INPUT_GAME_UP				"input_game_up"
#macro	INPUT_GAME_DOWN				"input_game_down"

// Macros that store the unique guid value and description for a given controller. In short, all supported
// controllers will have constants located here.
#macro	XINPUT_GAMEPAD			"none,XInput STANDARD GAMEPAD"
#macro	SONY_DUALSHOCK_FOUR		"4c05cc09000000000000504944564944,Sony DualShock 4"
#macro	SONY_DUALSENSE			"4c05e60c000000000000504944564944,Wireless Controller"
#macro	SWITCH_PRO_CONTROLLER	""

#endregion

#region Initializing enumerators that are useful/related to obj_music_handler

/// @description Values for each of the supported gamepads. This will prevent the game from having to load
/// in the same icons again if the player were to disconnect the previous controller before connect a new
/// one that uses the same icon group as that previous one.
enum Gamepad{
	None,
	Generic,
	Xbox,
	PlayStation,
	Nintendo,
}

#endregion

#region Initializing any globals that are useful/related to obj_control_info

// Since the keyboard itself doesn't need to account for changing icon sprites in order to match the currently
// connected AND supported controller, all the data can just be stored inside of a map; with each key being
// the keycode constant needed to retrieve the struct containing the keyboard's icon.
global.keyboardIcons = ds_map_create();
ds_map_add(global.keyboardIcons, vk_backspace,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 2}); 
ds_map_add(global.keyboardIcons, vk_tab,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 22}); 
ds_map_add(global.keyboardIcons, vk_enter,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 3});
ds_map_add(global.keyboardIcons, vk_shift,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 1}); 
ds_map_add(global.keyboardIcons, vk_pause,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 53}); 
ds_map_add(global.keyboardIcons, vk_capslock,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 4}); 
ds_map_add(global.keyboardIcons, vk_escape,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 27}); 
ds_map_add(global.keyboardIcons, vk_space,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 0}); 
ds_map_add(global.keyboardIcons, vk_pageup,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 24}); 
ds_map_add(global.keyboardIcons, vk_pagedown,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 25}); 
ds_map_add(global.keyboardIcons, vk_end,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 10}); 
ds_map_add(global.keyboardIcons, vk_home,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 7});
ds_map_add(global.keyboardIcons, vk_left,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 2});
ds_map_add(global.keyboardIcons, vk_up,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 0});
ds_map_add(global.keyboardIcons, vk_right,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 3});
ds_map_add(global.keyboardIcons, vk_down,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 1});
ds_map_add(global.keyboardIcons, vk_insert,			{iconSprite : spr_keyboard_icons_large,		imgIndex : 6});
ds_map_add(global.keyboardIcons, vk_delete,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 23});
ds_map_add(global.keyboardIcons, vk_0,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 52});
ds_map_add(global.keyboardIcons, vk_1,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 43});
ds_map_add(global.keyboardIcons, vk_2,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 44});
ds_map_add(global.keyboardIcons, vk_3,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 45});
ds_map_add(global.keyboardIcons, vk_4,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 46});
ds_map_add(global.keyboardIcons, vk_5,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 47});
ds_map_add(global.keyboardIcons, vk_6,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 48});
ds_map_add(global.keyboardIcons, vk_7,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 49});
ds_map_add(global.keyboardIcons, vk_8,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 50});
ds_map_add(global.keyboardIcons, vk_9,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 51});
ds_map_add(global.keyboardIcons, vk_a,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 4});
ds_map_add(global.keyboardIcons, vk_b,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 5});
ds_map_add(global.keyboardIcons, vk_c,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 6});
ds_map_add(global.keyboardIcons, vk_d,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 7});
ds_map_add(global.keyboardIcons, vk_e,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 8});
ds_map_add(global.keyboardIcons, vk_f,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 9});
ds_map_add(global.keyboardIcons, vk_g,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 10});
ds_map_add(global.keyboardIcons, vk_h,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 11});
ds_map_add(global.keyboardIcons, vk_i,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 12});
ds_map_add(global.keyboardIcons, vk_j,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 13});
ds_map_add(global.keyboardIcons, vk_k,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 14});
ds_map_add(global.keyboardIcons, vk_l,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 15});
ds_map_add(global.keyboardIcons, vk_m,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 16});
ds_map_add(global.keyboardIcons, vk_n,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 17});
ds_map_add(global.keyboardIcons, vk_o,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 18});
ds_map_add(global.keyboardIcons, vk_p,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 19});
ds_map_add(global.keyboardIcons, vk_q,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 20});
ds_map_add(global.keyboardIcons, vk_r,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 21});
ds_map_add(global.keyboardIcons, vk_s,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 22});
ds_map_add(global.keyboardIcons, vk_t,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 23});
ds_map_add(global.keyboardIcons, vk_u,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 24});
ds_map_add(global.keyboardIcons, vk_v,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 25});
ds_map_add(global.keyboardIcons, vk_w,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 26});
ds_map_add(global.keyboardIcons, vk_x,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 27});
ds_map_add(global.keyboardIcons, vk_y,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 28});
ds_map_add(global.keyboardIcons, vk_z,				{iconSprite : spr_keyboard_icons_small,		imgIndex : 29});
ds_map_add(global.keyboardIcons, vk_numpad0,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 12});
ds_map_add(global.keyboardIcons, vk_numpad1,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 13});
ds_map_add(global.keyboardIcons, vk_numpad2,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 14});
ds_map_add(global.keyboardIcons, vk_numpad3,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 15});
ds_map_add(global.keyboardIcons, vk_numpad4,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 16});
ds_map_add(global.keyboardIcons, vk_numpad5,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 17});
ds_map_add(global.keyboardIcons, vk_numpad6,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 18});
ds_map_add(global.keyboardIcons, vk_numpad7,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 19});
ds_map_add(global.keyboardIcons, vk_numpad8,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 20});
ds_map_add(global.keyboardIcons, vk_numpad9,		{iconSprite : spr_keyboard_icons_medium,	imgIndex : 21});
ds_map_add(global.keyboardIcons, vk_multiply,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 41});
ds_map_add(global.keyboardIcons, vk_add,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 38});
ds_map_add(global.keyboardIcons, vk_subtract,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 37});
ds_map_add(global.keyboardIcons, vk_decimal,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 31});
ds_map_add(global.keyboardIcons, vk_divide,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 32});
ds_map_add(global.keyboardIcons, vk_f1,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 0});
ds_map_add(global.keyboardIcons, vk_f2,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 1});
ds_map_add(global.keyboardIcons, vk_f3,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 2});
ds_map_add(global.keyboardIcons, vk_f4,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 3});
ds_map_add(global.keyboardIcons, vk_f5,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 4});
ds_map_add(global.keyboardIcons, vk_f6,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 5});
ds_map_add(global.keyboardIcons, vk_f7,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 6});
ds_map_add(global.keyboardIcons, vk_f8,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 7});
ds_map_add(global.keyboardIcons, vk_f9,				{iconSprite : spr_keyboard_icons_medium,	imgIndex : 8});
ds_map_add(global.keyboardIcons, vk_f10,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 9});
ds_map_add(global.keyboardIcons, vk_f11,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 10});
ds_map_add(global.keyboardIcons, vk_f12,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 11});
ds_map_add(global.keyboardIcons, vk_numberlock,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 9});
ds_map_add(global.keyboardIcons, vk_scrolllock,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 10});
ds_map_add(global.keyboardIcons, vk_control,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 5});
ds_map_add(global.keyboardIcons, vk_alt,			{iconSprite : spr_keyboard_icons_medium,	imgIndex : 26});
ds_map_add(global.keyboardIcons, vk_semicolon,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 33});
ds_map_add(global.keyboardIcons, vk_equal,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 55});
ds_map_add(global.keyboardIcons, vk_comma,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 30});
ds_map_add(global.keyboardIcons, vk_underscore,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 39});
ds_map_add(global.keyboardIcons, vk_period,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 31});
ds_map_add(global.keyboardIcons, vk_fslash,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 40});
ds_map_add(global.keyboardIcons, vk_backquote,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 42});
ds_map_add(global.keyboardIcons, vk_openbracket,	{iconSprite : spr_keyboard_icons_small,		imgIndex : 34});
ds_map_add(global.keyboardIcons, vk_bslash,			{iconSprite : spr_keyboard_icons_small,		imgIndex : 36});
ds_map_add(global.keyboardIcons, vk_closebracket,	{iconSprite : spr_keyboard_icons_small,		imgIndex : 36});
ds_map_add(global.keyboardIcons, vk_quotation,		{iconSprite : spr_keyboard_icons_small,		imgIndex : 54});

// Since the windows OS can differentiate between both right control and left control, as well as right alt
// and left alt, there needs to be unique use cases for these keys potentially being mapped as inputs; both
// as the default keyboard layout AND through player key rebindings. So, these map indexes are added to
// compensate for that on all Windows PCs.
if (os_type == os_windows){
	ds_map_add(global.keyboardIcons, vk_rcontrol,	{iconSprite : spr_keyboard_icons_xlarge,	imgIndex : 0});
	ds_map_add(global.keyboardIcons, vk_lcontrol,	{iconSprite : spr_keyboard_icons_xlarge,	imgIndex : 1});
	ds_map_add(global.keyboardIcons, vk_ralt,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 12});
	ds_map_add(global.keyboardIcons, vk_lalt,		{iconSprite : spr_keyboard_icons_large,		imgIndex : 13});
}

// Stores all of the gamepad's icons in a global map, so they can be properly cleaned from memory (And also so
// any duplicate structs can be replaced by pointers in the "inputIcons" map) when the information is no
// longer needed by the control info object.
global.gamepadIcons = ds_map_create();

#endregion

#region The main object code for obj_control_info

/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function obj_control_info(_index) : base_struct(_index) constructor{
	// Determines what object/struct will be able to manipulate the current information being displayed by
	// this object; adding, removing, editing, and positioning info.
	curOwner = noone;
	
	// Variables that handle the current opacity of all control information being displayed on the screen.
	// The alpha value will automatically update its value by the modfier value until it equals the target
	// value. This is done in the "step" event of this object.
	alpha = 0;
	alphaTarget = 0;
	alphaModifier = 0;
	
	// Stores all of the currently used icons for the game's current input bindings and the player's currently
	// active control input method (Can be keyboard or their gamepad, if it's supported).
	inputIcons = ds_map_create();
	prevGamepad = Gamepad.None;
	
	// Stores each of the anchor points, which each have a unique position and alignment. The control data
	// that is attached to each anchor is stored in a list within said anchor struct, and the order of these
	// anchors in the map are stored in a seperate list in order to have quick processing during rendering.
	anchorPoint = ds_map_create();
	pointOrder = ds_list_create();
	
	/// @description Cleans up any systems and variables that could potentially cause memory leaks if left
	/// unhandled while the game is still running. (Game Maker cleans it all up at the end of runtime by
	/// default, so it doesn't matter as much in that case)
	static cleanup = function(){
		// Clean up all the structs that were created for each supported key on a keyboard. Then, destroy the
		// map that stored all those struct to free it from memory as well.
		var _key = ds_map_find_first(global.keyboardIcons);
		while(!is_undefined(_key)){
			delete global.keyboardIcons[? _key];
			_key = ds_map_find_next(global.keyboardIcons, _key);
		}
		ds_map_destroy(global.keyboardIcons);

		// Much like above, the gamepad icon map will be cleared of any existing structs. Then, the map for
		// storing said data is destroyed to free that memory.
		clear_gamepad_icons();
		ds_map_destroy(global.gamepadIcons);

		// Destroy the map that stores all the icons that are tied to control inputs that are able to be
		// rendered if any currently active anchor has active control information to render.
		ds_map_destroy(inputIcons);
		
		// Finally, clear all anchor structs from memory before the map that stored said data is destroyed
		// from memory. Also, the list that stores the order of those anchors for quick map processing is
		// cleared from memory.
		clear_anchor_data();
		ds_map_destroy(anchorPoint);
		ds_list_destroy(pointOrder);
	}
	
	/// @description Code that should be placed into the "Step" event of whatever object is controlling
	/// obj_control_info. In short, it updates the alpha value by its modifier value to match the current 
	/// target value.
	step = function(){
		alpha = value_set_linear(alpha, alphaTarget, alphaModifier);
	}
	
	/// @description Code that should be placed into the "Draw GUI" event of whatever object is controlling
	/// obj_control_info. In short, it will handle rendering all of the control information at the positions
	/// calculated for said information on the game's screen; above all other GUI information.
	draw_gui = function(){
		if (alpha == 0) {return;}
		var _alpha = alpha; // Store in a local variable for use in anchor info structs.
		
		// First, the icons are rendered. The local "_x" and "_y" variables are used in order to pass the anchor's
		// position into the info struct, which the calculated offset positions are then added onto to get the
		// proper positions on screen. Each anchor's info list is looped through to render all existing icons.
		var _x = 0;
		var _y = 0;
		var _icon = -1;
		var _totalInputs = 0;
		var _totalPoints = ds_list_size(pointOrder);
		for (var i = 0; i < _totalPoints; i++){
			with(anchorPoint[? pointOrder[| i]]){
				_x = x;
				_y = y;
				_totalInputs = ds_list_size(info);
				for (var j = 0; j < _totalInputs; j++){
					with(info[| j]){
						_icon = inputIcons[? input];
						draw_sprite_ext(_icon.iconSprite, _icon.imgIndex, _x + iconX, _y + iconY, 1, 1, 0, c_white, _alpha);
					}
				}
			}
		}
		
		// Finally, the information text that is paired with the icon data that was previously rendered is
		// drawn. It uses another loop because of the shader the is required for the text; saving time that
		// would be used constantly setting and resetting the shader in order to prevent the icon from being
		// outlined like the text is. With this method, the shader is only ever set once for the entire loop.
		shader_set_outline(font_gui_small, RGB_GRAY);
		for (var ii = 0; ii < _totalPoints; ii++){
			with(anchorPoint[? pointOrder[| ii]]){
				_x = x;
				_y = y;
				_totalInputs = ds_list_size(info);
				for (var jj = 0; jj < _totalInputs; jj++){
					with(info[| jj]) {draw_text_outline(_x + infoX, _y + infoY, info, HEX_WHITE, RGB_GRAY, _alpha);}
				}
			}
		}
		shader_reset();
	}
	
	/// @description Initializes the icons that will be shown for each of the game's inputs. If a gamepad is
	/// currently active, the icon data will be pulled from the "global.gamepadIcons" ds_map, and if there
	/// isn't a gamepad active, the keyboard icons stored in the "global.keyboardIcons" will be used instead.
	initialize_input_icons = function(){
		if (GAMEPAD_IS_ACTIVE){ // Assigning icons that match the currently active gamepad.
			//get_gamepad_icons(gamepad_get_description(GAMEPAD_ID));
		} else{ // Assigning icons for the default input device: the keyboard.
			ds_map_clear(inputIcons); // Clear out the old struct pointers.
			ds_map_add(inputIcons, INPUT_GAME_RIGHT,		global.keyboardIcons[? KEYCODE_GAME_RIGHT]);	// Player movement inputs
			ds_map_add(inputIcons, INPUT_GAME_LEFT,			global.keyboardIcons[? KEYCODE_GAME_LEFT]);
			ds_map_add(inputIcons, INPUT_GAME_UP,			global.keyboardIcons[? KEYCODE_GAME_UP]);
			ds_map_add(inputIcons, INPUT_GAME_DOWN,			global.keyboardIcons[? KEYCODE_GAME_DOWN]);
		}
		
		// Once the valid input icon data have all been added to the "inputIcons" map, it will then be used to
		// determine the offset positions of all existing anchors' icon information.
		var _length = ds_list_size(pointOrder);
		for (var i = 0; i < _length; i++) {set_icon_positions(anchorPoint[? pointOrder[| i]]);}
	}
	
	/// @description Fills the "global.gamepadIcons" ds_map with control icons that match the currently 
	/// connected gamepad. The gamepad icons won't be refreshed if the same type of gamepad was connected
	/// and activated by the player.
	/// @param {String}	info
	get_gamepad_icons = function(_info){
		// Determine what sprite to use for the gamepad and what kind of gamepad it is through the use of
		// this switch statement. Unsupported controllers will simply use xbox controller icons as a default.
		var _sprite = NO_SPRITE;
		var _gamepad = Gamepad.None;
		switch(_info){
			case XINPUT_GAMEPAD:
				_sprite = spr_xbox_gamepad_icons;
				_gamepad = Gamepad.Xbox;
				break;
			case SONY_DUALSHOCK_FOUR:
			case SONY_DUALSENSE:
				_sprite = spr_dualshock_four_icons;
				_gamepad = Gamepad.PlayStation;
				break;
			default:
				_sprite = spr_xbox_gamepad_icons;
				_gamepad = Gamepad.Generic;
				break;
		}
		
		// If the gamepad that is requesting its icons shakes the same icons as the previously connected
		// gamepad, no updating of icon data will be performed and the function will exit prematurely.
		if (_gamepad == prevGamepad) {return;}
		clear_gamepad_icons();
		
		// Loop through all gamepad input constants and create a struct containing the image index and sprite
		// for the gamepad that is currently connected. Store the value of the gamepad that is connected after
		// to prevent unnecessary refreshing of any data.
		var _index = 0;
		for (var i = gp_face1; i <= gp_padr; i++){
			ds_map_add(global.gamepadIcons,	i,	{iconSprite : _sprite,	imgIndex : _index});
			_index++;
		}
		prevGamepad = _gamepad;
	}
	
	/// @description Clears out all the icon structs found within the "global.gamepadIcons" variable from 
	/// memory before removing all key/value pairs from the list; leaving a now empty map to fill with new
	/// icon data whenever required.
	clear_gamepad_icons = function(){
		var _key = ds_map_find_first(global.gamepadIcons);
		while(!is_undefined(_key)){
			delete global.gamepadIcons[? _key];
			_key = ds_map_find_next(global.gamepadIcons, _key);
		}
		ds_map_clear(global.gamepadIcons);
	}
	
	/// @description Completely clears out all structs and allocated memory from all currently existing
	/// anchors. After the memory has been properly managed, the map storing the anchors and the list storing
	/// the order of said anchors are cleared of their now undefined data.
	clear_anchor_data = function(){
		var _totalInputs = 0;
		var _totalPoints = ds_list_size(pointOrder);
		for (var i = 0; i < _totalPoints; i++){
			with(anchorPoint[? pointOrder[| i]]){
				_totalInputs = ds_list_size(info);
				for (var j = 0; j < _totalInputs; j++) {delete info[| i];}
				ds_list_destroy(info);
			}
			delete anchorPoint[? pointOrder[| i]];
		}
		ds_map_clear(anchorPoint);
		ds_list_clear(pointOrder);
	}
	
	/// @description Sets the position offsets for the currently available icons stored within the provided
	/// anchor struct. Depending on the alignment, the relevant function will be called (With the required
	/// argument settings) from the switch statement that makes up this function.
	/// @param {Struct} anchor
	set_icon_positions = function(_anchor){
		draw_set_font(font_gui_small);
		with(_anchor){
			switch(alignment){
				case ALIGNMENT_LEFT:	calculate_info_offset_horizontal(true);		break;
				case ALIGNMENT_RIGHT:	calculate_info_offset_horizontal(false);	break;
				case ALIGNMENT_UP:		calculate_info_offset_vertical(true);		break;
				case ALIGNMENT_DOWN:	calculate_info_offset_vertical(false);		break;
			}
		}
	}
}

#endregion

#region Global functions related to obj_control_info

/// @description Applies "ownership" to the control info's functionality. This is useful in preventing data
/// from being overwritten accidentally by an object that isn't currently in control of this object; showing
/// the wrong input information to the player as a result. Ownership can only be assigned
/// @param {Id.Instance}	instanceID
function control_info_set_owner(_instanceID){
	var _id = id;
	with(CONTROL_INFO){
		if (_id == id || (curOwner != noone && instance_exists(curOwner))) {return;}
		curOwner = _instanceID;
	}
}

/// @description Removes the current owner of the control info object's functionality. If an object other
/// than the one currently in control attempts to remove ownership of the control info object, the function
/// will not do anything. Otherwise, ownership will be successfully revoked.
function control_info_remove_owner(){
	var _id = id;
	with(CONTROL_INFO){
		if (_id != curOwner) {return;}
		curOwner = noone;
	}
}

/// @description Creates and stores a new anchor object that will be able to store control information data
/// that is properly aligned on the screen relative to the alignment setting and position of the anchor. If
/// there is already an anchor that shares the same name as the one set for creation in the arguments, no new
/// anchor will be created and the function will return before processing anything.
/// @param {String}	name
/// @param {Real}	x
/// @param {Real}	y
/// @param {Real}	alignment
function control_info_create_anchor(_name, _x, _y, _alignment){
	var _id = id;
	with(CONTROL_INFO){
		if (_id != curOwner || !is_undefined(anchorPoint[? _name])) {return;}
		
		// Create the struct that will hold the position, alignment, opacity, and the input information linked 
		// to said anchor. On top of that, the two functions for calculating the positional offsets for info
		// aligned either horizontally or vertically (Relative to the alignment method used for the anchro)
		// are found within an anchor struct.
		ds_map_add(anchorPoint, _name, {
			x :				_x,
			y :				_y,
			alignment :		_alignment,
			info :			ds_list_create(),
			
			/// @description Calculates the offset positions for the elements found for an anchor that is
			/// aligned horizontally (Either using "ALIGNMENT_RIGHT" or "ALIGNMENT_LEFT", respectively).
			/// @param {Id.DsMap}	inputIcons
			/// @param {Bool}		isLeftAligned
			calculate_info_offset_horizontal : function(_isLeftAligned){
				var _emptyInfo = false;
				var _xOffset = 0;
				var _length = ds_list_size(info);
				for (var i = 0; i < _length; i++){
					with(info[| i]){
						infoY = 2;
						
						// The bool "_emptyInfo" will determine how the spacing between the control icon info
						// is calculated. If there is info text to display, the spacing in pixels will be
						// larger than if there isn't text.
						_emptyInfo = (info == "");
						if (_isLeftAligned){
							// First, determine the offset of the control icon, and then add the width of the
							// sprite to the offset, which is where the info text will be positioned.
							iconX = _xOffset;
							_xOffset += sprite_get_width(inputIcons[? input].iconSprite);
							if (!_emptyInfo) {_xOffset += 2;}
							else {_xOffset++;}
							
							// Then, set the offset for the icon after the icon position has been set. Add
							// the width of the info text if there is actual info text for the input, but don't
							// add anything, otherwise.
							infoX = _xOffset;
							if (!_emptyInfo) {_xOffset += string_width(info) + 3;}
						} else{
							// First, info text needs to be processed; unlike the left aligned info which is
							// icon -> info. So, the offset of the info text is added to the offset (If there
							// is any info text to display) and then the text's offset is set to that value.
							if (!_emptyInfo) {_xOffset -= string_width(info);}
							infoX = _xOffset;
							
							// After the info position is processed, the icon is positioned; with its offset
							// taking into account the width of the sprite. An additional 2 pixels are added
							// and then another 3 after the icon position is set are added when the info text
							// isn't an empty string. 
							_xOffset -= sprite_get_width(inputIcons[? input].iconSprite);
							if (!_emptyInfo) {_xOffset -= 2;}
							else {_xOffset += 2;}
							iconX = _xOffset;
							if (!_emptyInfo) {_xOffset -= 3;}
						}
					}
				}
			},
			
			/// @description Calculating the offsets for any vertically aligned anchor data. Unlike the 
			/// hoizontally-aligned anchors, the offsets only need to take into account the height of the icon
			/// sprite; with the info being offset by the width of said icon as well.
			/// @param {Id.DsMap}	inputIcons
			/// @param {Bool}		isTopAligned
			calculate_info_offset_vertical : function(_isTopAligned){
				var _yOffset = 0;
				var _length = ds_list_size(info);
				for (var i = 0; i < _length; i++){
					with(info[| i]){
						if (_isTopAligned) {_yOffset -= sprite_get_height(spr_keyboard_icons_small);}
						iconY = _yOffset;
						infoX = sprite_get_width(inputIcons[? input].iconSprite) + 2;
						infoY = iconY + 2;
						if (!_isTopAligned) {_yOffset += sprite_get_height(spr_keyboard_icons_small) + 1;}
						else {_yOffset--;} // Add an addition one pixel spacing between top-aligned control info.
					}
				}
			}
		});
		ds_list_add(pointOrder, _name);
	}
}

/// @description Adds control information for the provided input to the desired anchor. This information will
/// store the positional offsets for both the input icon and its accompanying information, as well as the index
/// for the control info's "inputIcons" ds_list for quick access during rendering.
/// @param {String}	anchor
/// @param {Real}	input
/// @param {String}	info
function control_info_add_data(_anchor, _input, _info){
	var _id = id;
	with(CONTROL_INFO){
		var _data = anchorPoint[? _anchor];
		if (_id != curOwner || is_undefined(_data)) {return;}

		var _inputIcons = inputIcons;
		ds_list_add(_data.info, {
			inputIcons :	_inputIcons,
			input :			_input,
			iconX :			0,
			iconY :			0,
			info :			_info,
			infoX :			0,
			infoY :			0,
		});
	}
}

/// @description Assigns new input data to replace another input. It will search through the anchor provided
/// to find the input, so if the input is found on another anchor, the function won't be able to find the it.
/// @param {String}	anchor
/// @param {Real}	input
/// @param {Real}	newInput
/// @param {String}	newInfo
function control_info_edit_data(_anchor, _input, _newInput, _newInfo){
	var _id = id;
	with(CONTROL_INFO){
		var _data = anchorPoint[? _anchor];
		if (_id != curOwner || is_undefined(_data)) {return;}
	
		// Jump into scope of the supplied anchor in order to search for and replace the input data with the 
		// newly with what was previously found inside the struct (If that input can be found). Then, calculate 
		// the position offsets to reflect the new change in input and info.
		with(_data){
			var _length = ds_list_size(info);
			for (var i = 0; i < _length; i++){
				if (info[| i].input == _input){
					info[| i].input = _newInput;
					info[| i].info = _newInfo;
					break;
				}
			}
		}
		set_icon_positions(_data)
	}
}

/// @description Removes an input from the currently displayed control information. It doesn't require knowing 
/// the exact index in the list that said info is stored at; just the input that should be deleted and the 
/// anchor to search through.
/// @param {String}	anchor
/// @param {Real}	input
function control_info_remove_data(_anchor, _input){
	var _id = id;
	with(CONTROL_INFO){
		var _data = anchorPoint[? _anchor];
		if (_id != curOwner || is_undefined(_anchor)) {return;}
		
		// Jump into scope of the anchor specified in order to search through the icon data found in the 
		// anchor struct. If the input is found, it will delete the data from the list and then update the 
		// icon positions of other information accordingly.
		with(_data){
			var _length = ds_list_size(info);
			for (var i = 0; i < _length; i++){
				if (info[| i].input == _input){
					ds_list_delete(info, i);
					break;
				}
			}
		}
		set_icon_positions(_data);
	}
}

/// @description Initializes the positional offsets of the icon's and their respective info text for the 
/// anchor specified by the paramater in the function call.
/// @param {String}	anchor
function control_info_initialize_anchor(_anchor){
	var _id = id;
	with(CONTROL_INFO){
		var _data = anchorPoint[? _anchor];
		if (_id == curOwner && !is_undefined(_data)) {set_icon_positions(_data);}
	}
}

/// @description Clear out all of the control information that is found within the desired anchor. The result
/// is a now empty list found within said anchor, but the anchor's struct isn't deleted by this function.
/// @param anchor
function control_info_clear_anchor(_anchor){
	var _id = id;
	with(CONTROL_INFO){
		if (_id != curOwner) {return;}
		with(anchorPoint[? _anchor]){
			var _length = ds_list_size(info);
			for (var i = 0; i < _length; i++) {delete info[| i];}
			ds_list_clear(info);
		}
	}
}

/// @description Clears out all of the anchor data from the control info object. This means that all data in
/// the anchor ds_map is cleared AND deleted, so no anchor structs will exist.
function control_info_clear_data(){
	var _id = id;
	with(CONTROL_INFO){
		if (_id == curOwner && ds_map_size(anchorPoint) > 0) {clear_anchor_data();}
	}
}

/// @description Assigns a new target value for the control info's alpha level. The speed at which this target 
/// value is reached can also be set through this function.
/// @param {Real}	target
/// @param {Real}	modifier
function control_info_set_alpha_target(_target, _modifier){
	var _id = id;
	with(CONTROL_INFO){
		if (_id != curOwner) {return;}
		alphaTarget = _target;
		alphaModifier = _modifier;
	}
}

/// @description Resets all the alpha variables to their default values of zero. Useful for preventing the 
/// alpha from adjusting to an old target value that wasn't cleared.
function control_info_reset_alpha(){
	var _id = id;
	with(CONTROL_INFO){
		if (_id != curOwner) {return;}
		alpha = 0;
		alphaTarget = 0;
		alphaModifier = 0;
	}
}

#endregion