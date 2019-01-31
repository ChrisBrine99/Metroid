/// @descriptions Saves the player's options into a file called 'options'.
/// @param fileName

var fileName;
fileName = argument0;

// Delete the previous file
file_delete(fileName);
ini_open(fileName);

ini_write_real("Options", "Scanlines", global.option[0]);		// Scanlines
ini_write_real("Options", "V-Sync", global.option[1]);			// V-Sync
ini_write_real("Options", "Unused", global.option[2]);			// Unused option
ini_write_real("Options", "WindowScale", global.option[3]);		// Windowed-mode scaling

ini_write_real("KeyBindings", "RightKey", global.key[0]);		// Right Key binding
ini_write_real("KeyBindings", "LeftKey", global.key[1]);		// Left Key binding
ini_write_real("KeyBindings", "UpKey", global.key[2]);			// Up Key binding
ini_write_real("KeyBindings", "DownKey", global.key[3]);		// Down Key binding
ini_write_real("KeyBindings", "ShootKey", global.key[4]);		// Shoot Key binding
ini_write_real("KeyBindings", "JumpKey", global.key[5]);		// Jump Key binding
ini_write_real("KeyBindings", "BeamKey", global.key[6]);		// Beam Key binding
ini_write_real("KeyBindings", "EquipKey", global.key[7]);		// Equip Key binding
ini_write_real("KeyBindings", "PauseKey", global.key[8]);		// Pause Key binding
ini_write_real("KeyBindings", "SaveKey", global.key[9]);		// Save Key binding

ini_write_real("KeyBindings", "MenuUpKey", global.key[10]);		// Moving Up Key in menu
ini_write_real("KeyBindings", "MenuDownKey", global.key[11]);	// Moving Down Key in menu
ini_write_real("KeyBindings", "MenuRightKey", global.key[12]);	// Shifting Right Key in menu
ini_write_real("KeyBindings", "MenuLeftKey", global.key[13]);	// Shifting Left Key in menu
ini_write_real("KeyBindings", "MenuSelectKey", global.key[14]);	// Selection Key in menu
ini_write_real("KeyBindings", "ReturnKey", global.key[15]);		// Return Key in menus
ini_write_real("KeyBindings", "DeleteKey", global.key[16]);		// Delete File Key in menus

ini_close();