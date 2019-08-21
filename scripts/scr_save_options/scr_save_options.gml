/// @description Saves the player's preferred variables into an ini file for use the next time the game 
/// is launched.
/// @param filename

var filename;
filename = argument0 + ".ini";

// Open the options.ini file
ini_open(filename);

// Save the player's video options
ini_write_real("VIDEO", "res_scale", global.oVideo[0]);
ini_write_real("VIDEO", "full_screen", global.oVideo[1]);
ini_write_real("VIDEO", "vertical_sync", global.oVideo[2]);
ini_write_real("VIDEO", "bloom", global.oVideo[3]);
ini_write_real("VIDEO", "scanlines", global.oVideo[4]);

// SAve the player's audio options
ini_write_real("AUDIO", "master", global.oAudio[0]);
ini_write_real("AUDIO", "music", global.oAudio[1]);
ini_write_real("AUDIO", "player", global.oAudio[2]);
ini_write_real("AUDIO", "weapons", global.oAudio[3]);
ini_write_real("AUDIO", "environment", global.oAudio[4]);
ini_write_real("AUDIO", "gui", global.oAudio[5]);

// Saving the player's in-game keybindings
ini_write_real("KEYBINDINGS", "game_right", global.gKey[KEY.GAME_RIGHT]);
ini_write_real("KEYBINDINGS", "game_left", global.gKey[KEY.GAME_LEFT]);
ini_write_real("KEYBINDINGS", "game_up", global.gKey[KEY.GAME_UP]);
ini_write_real("KEYBINDINGS", "game_down", global.gKey[KEY.GAME_DOWN]);
ini_write_real("KEYBINDINGS", "use_weapon", global.gKey[KEY.USE_WEAPON]);
ini_write_real("KEYBINDINGS", "jump", global.gKey[KEY.JUMP]);
ini_write_real("KEYBINDINGS", "swap_weapon", global.gKey[KEY.SWAP_WEAPON]);
ini_write_real("KEYBINDINGS", "pause_game", global.gKey[KEY.PAUSE_GAME]);

// Saving the player's menu keybindings
ini_write_real("KEYBINDINGS", "menu_up", global.gKey[KEY.MENU_UP]);
ini_write_real("KEYBINDINGS", "menu_down", global.gKey[KEY.MENU_DOWN]);
ini_write_real("KEYBINDINGS", "menu_right", global.gKey[KEY.MENU_RIGHT]);
ini_write_real("KEYBINDINGS", "menu_left", global.gKey[KEY.MENU_LEFT]);
ini_write_real("KEYBINDINGS", "select", global.gKey[KEY.SELECT]);
ini_write_real("KEYBINDINGS", "return", global.gKey[KEY.RETURN]);

// Close the options.ini file
ini_close();