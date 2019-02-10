/// @description Loads the 'options' file into the game. If the file doesn't exists yet it will
/// create the file instead.
/// @param fileName

var fileName;
fileName = argument0;

// Open up a new file for reading.
ini_open(fileName);

global.option[0] = ini_read_real("Options", "Scanlines", true);			// Scanlines
global.option[1] = ini_read_real("Options", "V-Sync", false);			// V-Sync
global.option[2] = ini_read_real("Options", "ResolutionScale", 4);		// Resolution Scale
global.option[3] = ini_read_real("Options", "MusicVol", 100);			// Music Volume
global.option[4] = ini_read_real("Options", "SoundVol", 100);			// Sound Volume

global.key[0] = ini_read_real("KeyBindings", "RightKey", vk_right);		// Right Key binding
global.key[1] = ini_read_real("KeyBindings", "LeftKey", vk_left);		// Left Key binding
global.key[2] = ini_read_real("KeyBindings", "UpKey", vk_up);			// Up Key binding
global.key[3] = ini_read_real("KeyBindings", "DownKey", vk_down);		// Down Key binding
global.key[4] = ini_read_real("KeyBindings", "ShootKey", ord("Z"));		// Shoot/Deploy Key binding
global.key[5] = ini_read_real("KeyBindings", "JumpKey", ord("X"));		// Jump Key binding
global.key[6] = ini_read_real("KeyBindings", "BeamKey", vk_lshift);		// Beam Select Key binding
global.key[7] = ini_read_real("KeyBindings", "EquipKey", vk_lcontrol);	// Equipment Select Key binding
global.key[8] = ini_read_real("KeyBindings", "PauseKey", vk_escape);	// Pause Key binding
global.key[9] = ini_read_real("KeyBindings", "SaveKey", vk_enter);		// Save Key binding

global.key[10] = ini_read_real("KeyBindings", "MenuUpKey", vk_up);			// Moving Up in menus binding
global.key[11] = ini_read_real("KeyBindings", "MenuDownKey", vk_down);		// Moving Down in menus binding
global.key[12] = ini_read_real("KeyBindings", "MenuRightKey", vk_right);	// Shifting Right in menus binding
global.key[13] = ini_read_real("KeyBindings", "MenuLeftKey", vk_left);		// Shifting Left in menus binding
global.key[14] = ini_read_real("KeyBindings", "MenuSelectKey", ord("Z"));	// Selecting a menu option
global.key[15] = ini_read_real("KeyBindings", "ReturnKey", ord("X"));		// Returning to a previous menu
global.key[16] = ini_read_real("KeyBindings", "DeleteKey", ord("D"));		// Deleting a file menu binding

ini_close();