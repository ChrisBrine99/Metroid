/// @descriptions Saves the player's options into a file called 'options'.
/// @param fileName

var fileName;
fileName = argument0;

// Delete the previous file
file_delete(fileName);
ini_open(fileName);

ini_write_real("Options", "Scanlines", global.option[0]); // Scanlines
ini_write_real("Options", "V-Sync", global.option[1]); // V-Sync
ini_write_real("Options", "Unused", global.option[2]); // Unused option
ini_write_real("Options", "WindowScale", global.option[3]); // Windowed-mode scaling

/*
ini_write_real("KeyBindings", "UpKey", global.option[4]); // Up key binding
ini_write_real("KeyBindings", "DownKey", global.option[5]); // Down key binding
ini_write_real("KeyBindings", "LeftKey", global.option[6]); // Left key binding
ini_write_real("KeyBindings", "RightKey", global.option[7]); // Right key binding
ini_write_real("KeyBindings", "ShootKey", global.option[8]); // Shoot key binding
ini_write_real("KeyBingings", "JumpKey", global.option[9]); // Jump key binding
ini_write_real("KeyBindings", "BeamKey", global.option[10]); // Beam key binding
ini_write_real("KeyBindings", "EquipKey", global.option[11]); // Equip key binding
ini_write_real("KeyBindings", "MenuKey", global.option[12]); // Pause key binding*/

ini_close();