/// @description Initializes all global variables with default values.

// A map that stores all the texture data for the game's available fonts. The key is the number given
// to the font given by GML itself, which is a constant given by referencing the font resource itself.
global.fontTextures = ds_map_create();
// Since these key/vaue pairs aren't ever changed or updates, they should all be set below.
ds_map_add(global.fontTextures, font_gui_small,		font_get_texture(font_gui_small));
ds_map_add(global.fontTextures, font_gui_medium,	font_get_texture(font_gui_medium));
ds_map_add(global.fontTextures, font_gui_large,		font_get_texture(font_gui_large));

// Singleton variables that keep track of important instances; preventing them from being created multiple times
// which would cause a myriad of issues, if the game even ran at all with multiple instances of these objects.
global.controllerID = noone;		// For obj_controller
global.effectID = noone;			// For obj_shader_handler
global.playerID = noone;			// For obj_samus

// Holds the game's current state. This state determines the functionality of certain objects.
global.gameState = GameState.InGame;

// Two variables that allow for the use of a variable frame rate. The first tracks the difference in time between
// the frames relative to the target FPS, and the second determines the game's target FPS for one second of real 
// time. This value determines where delta time will equal to a value of 1.00.
global.deltaTime = 0;
global.targetFPS = 60;


global.items = ds_list_create();
for (var i = 0; i < Items.Length; i++){
	ds_list_add(global.items, 0);
}