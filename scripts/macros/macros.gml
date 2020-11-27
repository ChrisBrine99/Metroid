/// @description Stores all of the macro values referenced throughout the code.

// Global object depth and entity depth
#macro	GLOBAL_DEPTH				5
#macro	ENTITY_DEPTH				300

// In-game tile width/height in pixels
#macro	TILE_SIZE					16

// The width and height of the game's window
#macro	WINDOW_WIDTH				320
#macro	WINDOW_HEIGHT				180

// The values for determining the anchor used by a control prompt
#macro	LEFT_ANCHOR				   -1
#macro	RIGHT_ANCHOR				1

// Vector array indexes
#macro	X							0
#macro	Y							1

// Automatic movement constants
#macro	NO_MOVEMENT					[0, 0]
#macro	MOVE_RIGHT					[1, 0]
#macro	MOVE_LEFT					[-1, 0]
#macro	MOVE_UP						[0, -1]
#macro	MOVE_DOWN					[0, 1]

// Lighting constants //////////////////////////////////////////////////////////////

// Normal area/cave lighting
#macro	NORM_LIGHT_COLOR			[0.372, 0.455, 0.498]
#macro	NORM_BRIGHTNESS			   -0.05
#macro	NORM_CONTRAST				0.90
#macro	NORM_SATURATION				0.85

// Heated/lava-filled area/cave lighting
#macro	HEAT_LIGHT_COLOR			[1.000, 0.686, 0.000]
#macro	HEAT_BRIGHTNESS				0.05
#macro	HEAT_CONTRAST				1.30
#macro	HEAT_SATURATION				0.35

// Cold/ice-filled area/cave lighting
#macro	ICE_LIGHT_COLOR				[0.000, 0.180, 0.388]
#macro	ICE_BRIGHTNESS			   -0.20
#macro	ICE_CONTRAST				0.65
#macro	ICE_SATURATION				0.40

// Deep/dark area lighting
#macro	DEEP_LIGHT_COLOR			[0.001, 0.004, 0.012]
#macro	DEEP_BRIGHTNESS			   -0.45
#macro	DEEP_CONTRAST				0.40
#macro	DEEP_SATURATION				0.25

////////////////////////////////////////////////////////////////////////////////////

// Animation constants
#macro	ANIMATION_FPS				60

// Aiming constants
#macro	AIM_FORWARD					0
#macro	AIM_UPWARD					1
#macro	AIM_DOWNWARD				2

// Jump height constants
#macro	NORM_JUMP_SPEED			   -5.1
#macro	NORM_JUMP_SPEED_MORPH	   -4.0
#macro	HIGH_JUMP_SPEED			   -7.5
#macro	HIGH_JUMP_SPEED_MORPH	   -5.8