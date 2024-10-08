#region Additional vk_* macros for letters, numbers, and other keyboard keys

// ------------------------------------------------------------------------------------------------------- //
//	Virtual keyboard constants for all numberical keys ABOVE the letters on the player's actual keyboard.  //
// ------------------------------------------------------------------------------------------------------- //

#macro	vk_0					0x30
#macro	vk_1					0x31
#macro	vk_2					0x32
#macro	vk_3					0x33
#macro	vk_4					0x34
#macro	vk_5					0x35
#macro	vk_6					0x36
#macro	vk_7					0x37
#macro	vk_8					0x38
#macro	vk_9					0x39

// ------------------------------------------------------------------------------------------------------- //
// Virtual keyboard constants for all letters of the alphabet (Saves having to perform "ord(x)" calls).    //
// ------------------------------------------------------------------------------------------------------- //

#macro	vk_a					0x41
#macro	vk_b					0x42
#macro	vk_c					0x43
#macro	vk_d					0x44
#macro	vk_e					0x45
#macro	vk_f					0x46
#macro	vk_g					0x47
#macro	vk_h					0x48
#macro	vk_i					0x49
#macro	vk_j					0x4A
#macro	vk_k					0x4B
#macro	vk_l					0x4C
#macro	vk_m					0x4D
#macro	vk_n					0x4E
#macro	vk_o					0x4F
#macro	vk_p					0x50
#macro	vk_q					0x51
#macro	vk_r					0x52
#macro	vk_s					0x53
#macro	vk_t					0x54
#macro	vk_u					0x55
#macro	vk_v					0x56
#macro	vk_w					0x57
#macro	vk_x					0x58
#macro	vk_y					0x59
#macro	vk_z					0x5A

// ------------------------------------------------------------------------------------------------------- //
//	Virtual keyboard constants for any keys that aren't covered by Game Maker's default vk_* constants.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	vk_capslock				0x14
#macro	vk_numberlock			0x90
#macro	vk_scrolllock			0x91
#macro	vk_semicolon			0xBA	// Also ":"
#macro	vk_equal				0xBB	// Also "+"
#macro	vk_comma				0xBC	// Also "<"
#macro	vk_underscore			0xBD	// Also "-"
#macro	vk_period				0xBE	// Also ">"
#macro	vk_fslash				0xBF	// Also "?"
#macro	vk_backquote			0xC0	// Also "~"
#macro	vk_openbracket			0xDA	// Also "{"
#macro	vk_bslash				0xDC	// Also "|"
#macro	vk_closebracket			0xDD	// Also "}"
#macro	vk_quotation			0xDE	// Also "'"

#endregion

#region Global object macros

// ------------------------------------------------------------------------------------------------------- //
//	Constants that represent their respective default or "zero" values--representing the value that any    //
//	variable SHOULD be set to whenever it doesn't have a valid reference to whatever they represent.	   //
// ------------------------------------------------------------------------------------------------------- //

#macro	NO_STATE			   -20
#macro	NO_SOUND			   -21
#macro	NO_FUNCTION			   -22
#macro	NO_SPRITE			   -23

// ------------------------------------------------------------------------------------------------------- //
//	A macro replacement for the value that is returned by the built-in "object_get_parent" function when   //
//	there is no parent object assigned to the object in question.										   //
// ------------------------------------------------------------------------------------------------------- //

#macro	NO_PARENT			   -100

// ------------------------------------------------------------------------------------------------------- //
//	Macro values for constants that are returned by functions created by myself within the code.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ROOM_INDEX_INVALID     -200
#macro	EVENT_FLAG_INVALID	   -300

// ------------------------------------------------------------------------------------------------------- //
//	Two constants that refer to the coordinate that is tied to a given value of a 2D vector array. Helps   //
//	explain what the values of "0" and "1" refer to in the context of said arrays within the code.		   //
// ------------------------------------------------------------------------------------------------------- //

#macro	X						0
#macro	Y						1

// ------------------------------------------------------------------------------------------------------- //
// The number of frames that an object's sprite will play each second relative to their current sprite's   //
// animation speed, which is a value set in "frames per second" by GameMaker itself.					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	ANIMATION_FPS			60.0

// ------------------------------------------------------------------------------------------------------- //
//	The 8 cardinal directions that are utilized countless times throughout the code.					   //
// ------------------------------------------------------------------------------------------------------- //

#macro	DIRECTION_EAST			0.0
#macro	DIRECTION_NORTHEAST		45.0
#macro	DIRECTION_NORTH			90.0
#macro	DIRECTION_NORTHWEST		135.0
#macro	DIRECTION_WEST			180.0
#macro	DIRECTION_SOUTHWEST		225.0
#macro	DIRECTION_SOUTH			270.0
#macro	DIRECTION_SOUTHEAST		315.0
#macro	FULL_CIRCLE				360.0

// ------------------------------------------------------------------------------------------------------- //
//	Values that are utilized to represent an object (Usually an entity like the player or an enemy)		   //
//	moving to the right or to the left, respectively.													   //
// ------------------------------------------------------------------------------------------------------- //

#macro	MOVE_DIR_RIGHT			1
#macro	MOVE_DIR_LEFT		   -1

#endregion

#region Color hex value macros (ALL ARE IN BGR FORMAT)

#macro	HEX_WHITE				0xF8F8F8 // BGR = 248, 248, 248
#macro	HEX_LIGHT_GRAY			0xBCBCBC // BGR = 188, 188, 188
#macro	HEX_GRAY				0x7C7C7C // BGR = 124, 124, 124
#macro	HEX_DARK_GRAY			0x404040 // BGR =  64,  64,  64
#macro	HEX_BLACK				0x000000 // BGR =   0,   0,   0

#macro	HEX_LIGHT_RED			0x0038F8 // BGR =   0,  56, 248
#macro	HEX_RED					0x0010BC // BGR =   0,  16, 188
#macro	HEX_DARK_RED			0x000058 // BGR =   0,   0,  88

#macro	HEX_VERY_LIGHT_GREEN	0xB8F8B8 // BGR = 184, 248, 184
#macro	HEX_LIGHT_GREEN			0x54F858 // BGR =  84, 248,  88
#macro	HEX_GREEN				0x00A800 // BGR =   0, 168,   0
#macro	HEX_DARK_GREEN			0x008000 // BGR =   0, 120,   0
#macro	HEX_VERY_DARK_GREEN		0x005800 // BGR =   0,  88,   0

#macro	HEX_VERY_LIGHT_BLUE		0xFCE4A8 // BGR = 252, 228, 164
#macro	HEX_LIGHT_BLUE			0xFCBC3C // BGR = 252, 188,  60
#macro	HEX_BLUE				0xF87800 // BGR = 248, 120,   0
#macro	HEX_DARK_BLUE			0xE04000 // BGR = 224,  64,   0
#macro	HEX_VERY_DARK_BLUE		0x9C2000 // BGR = 156,  32,   0

#macro	HEX_LIGHT_YELLOW		0xA8E0FC // BGR = 168, 224, 252
#macro	HEX_YELLOW				0x00BCF8 // BGR =   0, 184, 248
#macro	HEX_DARK_YELLOW			0x007CAC // BGR =   0, 124, 172
#macro	HEX_VERY_DARK_YELLOW	0x003050 // BGR =   0,  48,  80

#macro	HEX_VERY_LIGHT_ORANGE	0xB0D0F0 // BGR = 176, 208, 240
#macro	HEX_LIGHT_ORANGE		0x44A0FC // BGR =  68, 160, 252
#macro	HEX_ORANGE				0x105CE4 // BGR =  16,  92, 228
#macro	HEX_DARK_ORANGE			0x003088 // BGR =   0,  48, 136

#macro	HEX_VERY_LIGHT_PURPLE	0xF8B8D8 // BGR = 248, 184, 216
#macro	HEX_LIGHT_PURPLE		0xF87898 // BGR = 248, 120, 152
#macro	HEX_PURPLE				0xFC4468 // BGR = 252,  68, 104
#macro	HEX_DARK_PURPLE			0xBC2844 // BGR = 188,  40,  68

#macro	HEX_VERY_LIGHT_PINK		0xE4CCFC // BGR = 228, 204, 252
#macro	HEX_LIGHT_PINK			0xE47CFC // BGR = 228, 124, 252
#macro	HEX_PINK				0xE400FC // BGR = 228,   0, 252
#macro	HEX_DARK_PINK			0xA400BC // BGR = 164,   0, 188
#macro	HEX_VERY_DARK_PINK		0x6E007C // BGR = 110,   0, 124

#endregion

#region Color rgb value array macros (R and B values swapped compared to equivalent hex value macros)

#macro	RGB_WHITE				[0.973, 0.973, 0.973] // RGB = 248, 248, 248
#macro	RGB_LIGHT_GRAY			[0.737, 0.737, 0.737] // RGB = 188, 188, 188
#macro	RGB_GRAY				[0.486, 0.486, 0.486] // RGB = 124, 124, 124
#macro	RGB_DARK_GRAY			[0.251, 0.251, 0.251] // RGB =  64,  64,  64
#macro	RGB_BLACK				[0.0,   0.0,   0.0  ] // RGB =   0,   0,   0

#macro	RGB_LIGHT_RED			[0.973, 0.226, 0.0  ] // RGB = 248,  56,   0
#macro	RGB_RED					[0.737, 0.063, 0.0  ] // RGB = 188,  16,   0
#macro	RGB_DARK_RED			[0.345, 0.0,   0.0	] // RGB =  88,   0,   0

#macro	RGB_VERY_LIGHT_GREEN	[0.722, 0.973, 0.772] // RGB = 184, 248, 184
#macro	RGB_LIGHT_GREEN			[0.345, 0.973, 0.329] // RGB =  88, 248,  84
#macro	RGB_GREEN				[0.0,   0.659, 0.0  ] // RGB =   0, 168,   0
#macro	RGB_DARK_GREEN			[0.0,   0.471, 0.0  ] // RGB =   0, 120,   0
#macro	RGB_VARY_DARK_GREEN		[0.0,   0.345, 0.0  ] // RGB =   0,  88,   0

#macro	RGB_VERY_LIGHT_BLUE		[0.643, 0.894, 0.988] // RGB = 164, 228, 252
#macro	RGB_LIGHT_BLUE			[0.235, 0.737, 0.988] // RGB =  60, 188, 252
#macro	RGB_BLUE				[0.0,   0.471, 0.973] // RGB =   0, 120, 248
#macro	RGB_DARK_BLUE			[0.0,   0.345, 0.973] // RGB =   0,  88, 248
#macro	RGB_VERY_DARK_BLUE		[0.0,   0.0,   0.737] // RGB =   0,   0, 188

#macro	RGB_LIGHT_YELLOW		[0.988, 0.878, 0.659] // RGB = 252, 224, 168
#macro	RGB_YELLOW				[0.972, 0.722, 0.0  ] // RGB = 248, 184,   0
#macro	RGB_DARK_YELLOW			[0.675, 0.486, 0.0  ] // RGB = 172, 124,   0
#macro	RGB_VERY_DARK_YELLOW	[0.314, 0.188, 0.0  ] // RGB =  80,  48,   0

#macro	RGB_VERY_LIGHT_ORANGE	[0.942, 0.816, 0.690] // RGB = 240, 208, 176
#macro	RGB_LIGHT_ORANGE		[0.973, 0.627, 0.267] // RGB = 252, 160,  68
#macro	RGB_ORANGE				[0.894, 0.361, 0.063] // RGB = 228,  92,  16
#macro	RGB_DARK_ORANGE			[0.533, 0.078, 0.0  ] // RGB = 136,  20,   0

#macro	RGB_VERY_LIGHT_PURPLE	[0.847, 0.722, 0.973] // RGB = 216, 184, 248
#macro	RGB_LIGHT_PURPLE		[0.596, 0.471, 0.973] // RGB = 248, 120, 152
#macro	RGB_PURPLE				[0.408, 0.267, 0.988] // RGB = 104,  68, 252
#macro	RGB_DARK_PURPLE			[0.267, 0.157, 0.737] // RGB =  68,  40, 188

#endregion

#region Singleton Instance Macros

// Constants that shrink down the typing needed and overall clutter caused by having to reference any of the
// game's singleton objects. If any of these objects are destroyed, the game should close in order to prevent
// crashes or oddities from occuring.
#macro	CAMERA						global.sInstances[? obj_camera]
#macro	MUSIC_HANDLER				global.sInstances[? obj_music_handler]
#macro	EFFECT_HANDLER				global.sInstances[? obj_effect_handler]
#macro	CUTSCENE_MANAGER			global.sInstances[? obj_cutscene_manager]
#macro	TEXTBOX_HANDLER				global.sInstances[? obj_textbox_handler]
#macro	CONTROL_INFO				global.sInstances[? obj_control_info]
#macro	SCREEN_FADE					global.sInstances[? obj_screen_fade]
#macro	GAME_HUD					global.sInstances[? obj_game_hud]
#macro	MAP_MANAGER					global.sInstances[? obj_map_manager]
#macro	CONTROLLER					global.sInstances[? obj_controller]
#macro	PLAYER						global.sInstances[? obj_player]
#macro	DEBUGGER					global.sInstances[? obj_debugger]

#endregion