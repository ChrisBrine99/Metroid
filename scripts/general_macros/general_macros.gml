/// @description Stores all constant values that are used all throughout the game's code. From values like
/// keyboard inputs that aren't covered by the built-in vk_* constants, to unique colors, game settings, input
/// bindings, keys for important data structures; all global constants are found here. (Object specific macros
/// will be placed in the Create Event or script file since they are only used by that object/script)

#region Additional vk_* macros for letters, numbers, and other keyboard keys

// Virtual keyboard constants for all numberical keys ABOVE the letters on the keyboard
#macro	vk_0					48
#macro	vk_1					49
#macro	vk_2					50
#macro	vk_3					51
#macro	vk_4					52
#macro	vk_5					53
#macro	vk_6					54
#macro	vk_7					55
#macro	vk_8					56
#macro	vk_9					57

// Virtual keyboard constants for all letters of the alphabet
#macro	vk_a					65
#macro	vk_b					66
#macro	vk_c					67
#macro	vk_d					68
#macro	vk_e					69
#macro	vk_f					70
#macro	vk_g					71
#macro	vk_h					72
#macro	vk_i					73
#macro	vk_j					74
#macro	vk_k					75
#macro	vk_l					76
#macro	vk_m					77
#macro	vk_n					78
#macro	vk_o					79
#macro	vk_p					80
#macro	vk_q					81
#macro	vk_r					82
#macro	vk_s					83
#macro	vk_t					84
#macro	vk_u					85
#macro	vk_v					86
#macro	vk_w					87
#macro	vk_x					88
#macro	vk_y					89
#macro	vk_z					90

// Virtual keyboard constants for any other keys that aren't covered by Game Maker's default vk_* constants
#macro	vk_capslock				20
#macro	vk_numberlock			144
#macro	vk_scrolllock			145
#macro	vk_semicolon			186		// Also ":"
#macro	vk_equal				187		// Also "+"
#macro	vk_comma				188		// Also "<"
#macro	vk_underscore			189		// Also "-"
#macro	vk_period				190		// Also ">"
#macro	vk_fslash				191		// Also "?"
#macro	vk_backquote			192		// Also "~"
#macro	vk_openbracket			218		// Also "{"
#macro	vk_bslash				220		// Also "|"
#macro	vk_closebracket			221		// Also "}"
#macro	vk_quotation			222		// Also "'"

#endregion

#region Global object macros

// Constants that represent their respective default or "zero" values--representing the value that any 
// variable SHOULD be set to whenever it doesn't have a valid reference to whatever they represent.
#macro	NO_STATE			   -20
#macro	NO_SOUND			   -21
#macro	NO_FUNCTION			   -22
#macro	NO_SPRITE			   -23

// A macro replacement for the value that is returned by the built-in "object_get_parent" function when there
// is no parent object assigned to the object in question. 
#macro	NO_PARENT			   -100

// Macro values for constants that are returned by functions created by myself within the code.
#macro	ROOM_INDEX_INVALID     -200
#macro	EVENT_FLAG_INVALID	   -300

// Two constants that refer to the coordinate that is tied to a given value of a 2D vector array. Helps
// explain what the values of "0" and "1" refer to in the context of said vector within the code.
#macro	X						0
#macro	Y						1

// The number of frames that an object's sprite will play each second relative to their current sprite's
// animation speed, which is a value set in "frames per second" by GameMaker itself.
#macro	ANIMATION_FPS			60

#endregion

#region Color hex value macros (ALL ARE IN BGR FORMAT)

#macro	HEX_WHITE				0xF8F8F8 // BGR = 248, 248, 248
#macro	HEX_LIGHT_GRAY			0xBCBCBC // BGR = 188, 188, 188
#macro	HEX_GRAY				0x7C7C7C // BGR = 124, 124, 124
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
#macro	HEX_DARK_BLUE			0xF85800 // BGR = 248,  88,   0
#macro	HEX_VERY_DARK_BLUE		0xBC0000 // BGR = 188,   0,   0

#macro	HEX_LIGHT_YELLOW		0xA8E0FC // BGR = 168, 224, 252
#macro	HEX_YELLOW				0x00BCF8 // BGR =   0, 184, 248
#macro	HEX_DARK_YELLOW			0x007CAC // BGR =   0, 124, 172
#macro	HEX_VERY_DARK_YELLOW	0x003050 // BGR =   0,  48,  80

#macro	HEX_VERY_LIGHT_ORANGE	0xB0D0F0 // BGR = 176, 208, 240
#macro	HEX_LIGHT_ORANGE		0x44A0FC // BGR =  68, 160, 252
#macro	HEX_ORANGE				0x105CE4 // BGR =  16,  92, 228
#macro	HEX_DARK_ORANGE			0x001488 // BGR =   0,  20, 136

#macro	HEX_VERY_LIGHT_PURPLE	0xF8B8D8 // BGR = 248, 184, 216
#macro	HEX_LIGHT_PURPLE		0xF87898 // BGR = 248, 120, 152
#macro	HEX_PURPLE				0xFC4468 // BGR = 252,  68, 104
#macro	HEX_DARK_PURPLE			0xBC2844 // BGR = 188,  40,  68

#endregion

#region Color rgb value array macros (R and B values flipped from hex values)

// Each constant refers to the same shades as the hex constants above, but in an RGB array format instead.
#macro	RGB_WHITE				[0.972, 0.972, 0.972] // RGB = 248, 248, 248
#macro	RGB_LIGHT_GRAY			[0.75 , 0.75 , 0.75 ] // RGB = 191, 191, 191
#macro	RGB_GRAY				[0.5  , 0.5  , 0.5  ] // RGB = 127, 127, 127
#macro	RGB_DARK_GRAY			[0.25 , 0.25 , 0.25 ] // RGB =  64,  64,  64
#macro	RGB_VERY_DARK_GRAY		[0.125, 0.125, 0.125] // RGB =  32,  32,  32
#macro	RGB_BLACK				[0    , 0    , 0    ] // RGB =   0,   0,   0

// Each constant refers to the same reds as the hex constants above, but in an RGB array format instead.
#macro	RGB_LIGHT_RED			[0.972, 0.219, 0    ] // RGB = 248,  88,   0
#macro	RGB_RED					[0.737, 0    , 0    ] // RGB = 188,   0,   0
#macro	RGB_DARK_RED			[0.368, 0    , 0    ] // RGB =  94,   0,   0

// Each constant refers to the same greens as the hex constants above, but in an RGB array format instead.
#macro	RGB_LIGHT_GREEN			[0.345, 0.972, 0    ] // RGB =  88, 248,   0
#macro	RGB_GREEN				[0    , 0.721, 0    ] // RGB =   0, 184,   0
#macro	RGB_DARK_GREEN			[0    , 0.345, 0    ] // RGB =   0,  88,   0

// Each constant refers to the same blues as the hex constants above, but in an RGB array format instead.
#macro	RGB_VERY_LIGHT_BLUE		[0.407, 0.533, 0.988] // RGB = 104, 136, 252
#macro	RGB_LIGHT_BLUE			[0    , 0.345, 0.972] // RGB =   0,  88, 248
#macro	RGB_BLUE				[0    , 0    , 0.737] // RGB =   0,   0, 188
#macro	RGB_DARK_BLUE			[0	  , 0    , 0.368] // RGB =   0,   0,  94
#macro	RGB_VERY_DARK_BLUE		[0    , 0    , 0.156] // RGB =   0,   0,  40

// Each constant refers to the same yellows as the hex constants above, but in an RGB array format instead.
#macro	RGB_LIGHT_YELLOW		[1    , 0.913, 0.5  ] // RGB = 255, 233, 127
#macro	RGB_YELLOW				[1    , 0.862, 0    ] // RGB = 255, 220,   0
#macro	RGB_DARK_YELLOW			[0.498, 0.447, 0.247] // RGB = 127, 114,  63

#endregion
