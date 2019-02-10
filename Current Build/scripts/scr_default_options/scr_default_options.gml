/// @description The default options that the game starts with on first start up (Or whenever the options ini
/// gets deleted by the user.

// Options that can be toggled ///////////////////////////////////

global.option[0] = true;	// The scanline toggle
global.option[1] = false;	// The vsync toggle
global.option[2] = 4;		// Windowed mode scale
global.option[3] = 75;		// Music Volume
global.option[4] = 85;		// Sound Effect Volume

// The Default Keybindings ///////////////////////////////////////

global.key[0] = vk_right;	// Right button in-game
global.key[1] = vk_left;	// Left button in-game
global.key[2] = vk_up;		// Up button in-game
global.key[3] = vk_down;	// Down button in-game
global.key[4] = ord("Z");	// 'B' button in-game
global.key[5] = ord("X");	// 'A' button in-game
global.key[6] = vk_lshift;	// Select button in-game
global.key[7] = vk_lcontrol;// 'Other' Select button in-game
global.key[8] = vk_escape;	// Pause button in-game
global.key[9] = vk_enter;	// The save button in-game

global.key[10] = vk_up;		// The up button for menus
global.key[11] = vk_down;	// The down button for menus
global.key[12] = vk_right;	// The right button for menus
global.key[13] = vk_left;	// The left button for menus
global.key[14] = ord("Z");	// The select button for menus
global.key[15] = ord("X");	// The back button for menus
global.key[16] = ord("D");	// The delete file button for menus

//////////////////////////////////////////////////////////////////

display_reset(0, global.option[1]);
if (instance_exists(obj_camera))
	obj_camera.scale = global.option[2];