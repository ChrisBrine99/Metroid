/// @description The default options that the game starts with on first start up (Or whenever the options ini
/// gets deleted by the user.

// Options that can be toggled ///////////////////////////////////

global.option[0] = true;	// The scanline toggle
global.option[1] = false;	// The vsync toggle
global.option[2] = false;	// Unused option
global.option[3] = 4;		// Windowed mode scale

// The Default Keybindings ///////////////////////////////////////

global.option[4] = vk_up;		// Up button in-game
global.option[5] = vk_down;		// Down button in-game
global.option[6] = vk_left;		// Left button in-game
global.option[7] = vk_right;	// Right button in-game
global.option[8] = ord("Z");	// 'B' button in-game
global.option[9] = ord("X");	// 'A' button in-game
global.option[10] = vk_shift;	// Select button in-game
global.option[11] = vk_control;	// 'Other' Select button in-game
global.option[12] = vk_escape;	// Pause button in-game

//////////////////////////////////////////////////////////////////

display_reset(0, global.option[1]);
if (instance_exists(obj_camera))
	obj_camera.scale = global.option[3];