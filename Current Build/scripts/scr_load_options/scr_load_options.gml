/// @description Loads the 'options' file into the game. If the file doesn't exists yet it will
/// create the file instead.
/// @param fileName

var fileName;
fileName = argument0;

// Open up a new file for reading.
ini_open(fileName);

global.option[0] = ini_read_real("Options", "Scanlines", true); // Scanlines
global.option[1] = ini_read_real("Options", "V-Sync", false); // V-Sync
global.option[2] = ini_read_real("Options", "Unused", false); // Unused
global.option[3] = ini_read_real("Options", "WindowScale", 4); // Window Scale

ini_close();