// First, global struct instances will be cleaned up and removed from memory. On top of that, the buffer that
// held the flags for the game's various events is deleted.
with(GAME_SETTINGS)		{cleanup();}	delete GAME_SETTINGS;
with(AUDIO_MANAGER)		{cleanup();}	delete AUDIO_MANAGER;
										delete GAME_MANAGER;
										delete GAMEPAD_MANAGER;
										delete SHADER_OUTLINE;
										delete SHADER_FEATHERING;
buffer_delete(EVENT_HANDLER);

// After all global structs have been cleaned up, the existing Struct instances will have their cleanup events
// called before they are also deleted; destroying the list that held the pointers to these instances afterward.
var _instance = noone;
var _length = ds_list_size(global.structs);
for (var i = 0; i < _length; i++){
	_instance = global.structs[| i];
	if (is_undefined(_instance)) {continue;}
	with(_instance) {cleanup();}
	delete _instance;
}
ds_list_destroy(global.structs);

// Remove the map that stored the instance pointers for all singleton objects that existed within the game.
ds_map_clear(global.sInstances);
ds_map_destroy(global.sInstances);

// Destroy the list that held all the currently active instances of menu structs. Their cleanup functions and
// "pointer" values do not need to be managed because the main list for all struct instances does that already.
ds_list_destroy(global.menuInstances);

// 
_length = ds_list_size(global.lightSources);
for (var i = 0; i < _length; i++) {delete global.lightSources[| i];}

// Destroy all of the interactable components that existed within the game's data when it was set to close
// down. After all the interact components have been freed from memory, the list is destroyed to clear it
// from memory.
/*_length = ds_list_size(global.interactables);
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