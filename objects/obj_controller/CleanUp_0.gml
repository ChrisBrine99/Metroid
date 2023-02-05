// Destroy each singleton; cleaning up all their allocated data in the form of data structures, surfaces, and so
// on. For the player, the cleanup event is automatically called by GML's "instance_destroy" function, but for
// the other struct singletons their cleanups must be called before their pointer's deletion if the contain
// that function.
with(CAMERA)			{cleanup();}	delete CAMERA;
with(MUSIC_HANDLER)		{cleanup();}	delete MUSIC_HANDLER;
with(EFFECT_HANDLER)	{cleanup();}	delete EFFECT_HANDLER;
with(CUTSCENE_MANAGER)	{cleanup();}	delete CUTSCENE_MANAGER;
with(TEXTBOX_HANDLER)	{cleanup();}	delete TEXTBOX_HANDLER;
with(CONTROL_INFO)		{cleanup();}	delete CONTROL_INFO;
with(GAME_SETTINGS)		{cleanup();}	delete GAME_SETTINGS;
with(AUDIO_MANAGER)		{cleanup();}	delete AUDIO_MANAGER;
										delete SCREEN_FADE;
										delete GAME_MANAGER;
										delete GAMEPAD_MANAGER;
										delete SHADER_OUTLINE;
										delete SHADER_FEATHERING;
buffer_delete(EVENT_HANDLER);

// Destroy all existing menus and clean up their structs by calling each of their "menu_cleanup" functions.
// After that, delete the list that held all of the pointers to all current menus to free it from memory as well.
var _length = ds_list_size(global.menuInstances);
for (var i = 0; i < _length; i++){
	with(global.menuInstances[| i]) {cleanup();}
	delete global.menuInstances[| i];
}
ds_list_destroy(global.menuInstances);

// Destroy all of the interactable components that existed within the game's data when it was set to close
// down. After all the interact components have been freed from memory, the list is destroyed to clear it
// from memory.
_length = ds_list_size(global.interactables);
for (var i = 0; i < _length; i++) {delete global.interactables[| i];}
ds_list_destroy(global.interactables);

// Clear out any structs that were contained within the player's item inventory before the execution of the game
// can be halted. Also, remove the data structures used for both the note and map inventories as well.
_length = array_length(global.items);
for (var i = 0; i < _length; i++){
	if (is_struct(global.items[i])){
		delete global.items[i];
		global.items[i] = noone;
	}
}
ds_list_destroy(global.notes);

// Much like the item inventory, the world item data will have to have its memory cleared out manally by
// looping through the entire contents of the map. After that, the map and paired list are dleeted to clear
// them from memory as well.
var _key = ds_map_find_first(global.worldItemData);
while(!is_undefined(_key)){
	ds_list_destroy(global.worldItemData[? _key]);
	_key = ds_map_find_next(global.worldItemData, _key);
}
ds_map_destroy(global.worldItemData);
ds_list_destroy(global.collectedItems);