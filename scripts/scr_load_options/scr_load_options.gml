/// @description Loads up the player's unique option setup. This includes keybindings, video, and audio options.
/// If no options file can be found, the options will be assigned their default values
/// @param filename

var filename;
filename = argument0 + ".ini";

if (file_exists(filename)){
	// Open the options.ini file
	ini_open(filename);

	// Load in the video options
	global.oVideo[0] = ini_read_real("VIDEO", "res_scale", 4);			// The scale of the resolution relative to the original (320 by 180)
	global.oVideo[1] = ini_read_real("VIDEO", "full_screen", false);	// Whether the game should load in fullscreen mode or not
	global.oVideo[2] = ini_read_real("VIDEO", "vertical_sync", false);	// Determines if vertical syncronization is enabled or not
	global.oVideo[3] = ini_read_real("VIDEO", "bloom", true);			// Enables and disables the game's bloom shader (Can improve performance)
	global.oVideo[4] = ini_read_real("VIDEO", "scanlines", true);		// Enables and disables the in-game scanline filter

	// Load in the audio options
	global.oAudio[0] = ini_read_real("AUDIO", "master", 100);		// Determines the overall volume of all in-game sounds and music
	global.oAudio[1] = ini_read_real("AUDIO", "music", 65);			// Determines the volume of music in the game
	global.oAudio[2] = ini_read_real("AUDIO", "player", 60);		// Determines the volume of sounds produced by the player
	global.oAudio[3] = ini_read_real("AUDIO", "weapons", 75);		// Sets how loud the in-game weapon sounds are
	global.oAudio[4] = ini_read_real("AUDIO", "environment", 75);	// Sets the volume for sounds produced by the environment
	global.oAudio[5] = ini_read_real("AUDIO", "gui", 85);			// Determines the volume of the game's menus

	// Load in the player's preferred in-game keybindings
	global.gKey[KEY.GAME_RIGHT] = ini_read_real("KEYBINDINGS", "game_right", vk_right);		// The keybinding for moving the player object to the right
	global.gKey[KEY.GAME_LEFT] = ini_read_real("KEYBINDINGS", "game_left", vk_left);		// The keybinding for moving the player object to the left
	global.gKey[KEY.GAME_UP] = ini_read_real("KEYBINDINGS", "game_up", vk_up);				// The keybinding for letting the player aim upward/stand up/exit morphball
	global.gKey[KEY.GAME_DOWN] = ini_read_real("KEYBINDINGS", "game_down", vk_down);		// The keybinding for letting the player aim downward/crouch/enter morphball
	global.gKey[KEY.USE_WEAPON] = ini_read_real("KEYBINDINGS", "use_weapon", ord("Z"));		// The keybinding for firing/using the player's currently equipped weapon
	global.gKey[KEY.JUMP] = ini_read_real("KEYBINDINGS", "jump", ord("X"));					// The keybinding for allowing the player to jump
	global.gKey[KEY.SWAP_WEAPON] = ini_read_real("KEYBINDINGS", "swap_weapon", vk_shift);	// The keybinding for both quick swapping weapons and opening the weapon menu
	global.gKey[KEY.PAUSE_GAME] = ini_read_real("KEYBINDINGS", "pause_game", vk_escape);	// The keybinding to pause/unpause the game

	// Load in the player's preferred menu keybindings
	global.mKey[KEY.MENU_UP] = ini_read_real("KEYBINDINGS", "menu_up", vk_up);			// The keybinding for moving up in a menu
	global.mKey[KEY.MENU_DOWN] = ini_read_real("KEYBINDINGS", "menu_down", vk_down);	// The keybinding for moving down in a menu
	global.mKey[KEY.MENU_RIGHT] = ini_read_real("KEYBINDINGS", "menu_right", vk_right);	// The keybinding for increasing a value in the settings menu 
	global.mKey[KEY.MENU_LEFT] = ini_read_real("KEYBINDINGS", "menu_left", vk_left);	// The keybinding for decreasing a value in the settings menu
	global.mKey[KEY.SELECT] = ini_read_real("KEYBINDINGS", "select", ord("Z"));			// The keybinding selecting the current highlighted menu item
	global.mKey[KEY.RETURN] = ini_read_real("KEYBINDINGS", "return", ord("X"));			// The keybinding for return to a previous menu/closing a menu

	// Close the options.ini file
	ini_close();
} else{
	// Default audio and video options
	global.oVideo = [4, false, false, true, true];
	global.oAudio = [100, 65, 60, 75, 75, 85];
	
	// Default in-game keybindings
	global.gKey[KEY.GAME_RIGHT] = vk_right;
	global.gKey[KEY.GAME_LEFT] = vk_left;
	global.gKey[KEY.GAME_UP] = vk_up;
	global.gKey[KEY.GAME_DOWN] = vk_down;
	global.gKey[KEY.USE_WEAPON] = ord("Z");
	global.gKey[KEY.JUMP] = ord("X");
	global.gKey[KEY.SWAP_WEAPON] = vk_shift;
	global.gKey[KEY.PAUSE_GAME] = vk_escape;

	// Load in the player's preferred menu keybindings
	global.mKey[KEY.MENU_UP] = vk_up;
	global.mKey[KEY.MENU_DOWN] = vk_down;
	global.mKey[KEY.MENU_RIGHT] = vk_right;
	global.mKey[KEY.MENU_LEFT] = vk_left;
	global.mKey[KEY.SELECT] = ord("Z");
	global.mKey[KEY.RETURN] = ord("X");
}