// 
gpu_set_alphatestenable(true);
application_surface_draw_enable(false);

// Instantiate all singleton objects and structs here. These will exist for the entire duration of the game, and
// will prevent any from being destroyed until the game triggers its closing event through "game_end".
instance_create_singleton_struct(obj_camera);
instance_create_singleton_struct(obj_music_handler);
instance_create_singleton_struct(obj_effect_handler);
//instance_create_singleton_struct(obj_cutscene_manager);
//instance_create_singleton_struct(obj_textbox_handler);
//instance_create_singleton_struct(obj_control_info);
instance_create_singleton_struct(obj_game_hud);
instance_create_singleton_struct(obj_map_manager);
instance_create_singleton_struct(obj_screen_fade);
instance_create_singleton_struct(obj_debugger);
instance_create_singleton_object(0, 0, obj_controller);
instance_create_singleton_object(0, 0, obj_player);
instance_create_singleton_object(0, 0, obj_controller);

//
audio_group_load(samus_fanfares);

// Attempt to load in the game's settings from a saved .ini file. If no file currently exists, default settings
// will be used instead.
game_load_settings();

// By default, all keyboard icons are set to keyboard. (Since this is the PC version...) This function will
// initialize the control info icons to that control method.
//CONTROL_INFO.initialize_input_icons();

// Finally, once all the initialization has completed, move into the first true room of the game.
//room_goto(rm_test_main);
room_goto(rm_areaone_01);

/// FOR TESTING
show_debug_overlay(true);
//audio_debug(true);
//texture_debug_messages(true);
audio_set_linked_object(PLAYER, 0, -16);

// 
map_initialize(MAP_AREA_ONE, 64, 64);
with(MAP_MANAGER){
	// "rm_areaone_01"
	create_map_cell(20, 14, CELL_FOURTEEN_B);
	create_map_cell(20, 15, CELL_FOURTEEN_B);
	create_map_cell(20, 16, CELL_TWENTYFIVE_A);
	create_map_cell(21, 16, CELL_SIX_C);
		create_map_door(21, 16, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
	// "rm_areaone_02"
	create_map_cell(22, 16, CELL_SIX_A);
		create_map_door(22, 16, CELL_DOOR_WEST, CELL_DOOR_ANYWEAPON);
	create_map_cell(23, 16, CELL_FOURTEEN_A);
	create_map_cell(24, 16, CELL_FOURTEEN_A);
	create_map_cell(25, 16, CELL_TWELVE_A);
		create_map_door(25, 16, CELL_DOOR_NORTH, CELL_DOOR_MISSILE);
	create_map_cell(26, 16, CELL_TWENTYTHREE_D);
	create_map_cell(27, 16, CELL_SIX_C);
		create_map_door(27, 16, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
	create_map_cell(24, 17, CELL_FOURTEEN_B, CELL_HIDDEN);
	create_map_cell(26, 17, CELL_FOURTEEN_B);
	create_map_cell(24, 18, CELL_FOURTEEN_B, CELL_HIDDEN);
	create_map_cell(26, 18, CELL_FOURTEEN_B);
	create_map_cell(24, 19, CELL_ELEVEN_D);
	create_map_cell(26, 19, CELL_FOURTEEN_B);
	create_map_cell(22, 20, CELL_SIX_A);
		create_map_door(22, 20, CELL_DOOR_WEST, CELL_DOOR_ANYWEAPON);
	create_map_cell(23, 20, CELL_FOURTEEN_A);
	create_map_cell(24, 20, CELL_TWENTYTHREE_B);
	create_map_cell(25, 20, CELL_FOURTEEN_A);
	create_map_cell(26, 20, CELL_TWENTYTHREE_B);
	create_map_cell(27, 20, CELL_SIX_C);
		create_map_door(27, 20, CELL_DOOR_EAST, CELL_DOOR_MISSILE);
	// "rm_areaone_03"
	create_map_cell(19, 20, CELL_TWENTYSEVEN_D);
		create_map_door(19, 20, CELL_DOOR_WEST, CELL_DOOR_MISSILE);
	create_map_cell(20, 20, CELL_FOURTEEN_A);
	create_map_cell(21, 20, CELL_SIX_C);
		create_map_door(21, 20, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
	create_map_cell(19, 21, CELL_SEVEN_B);
		create_map_door(19, 21, CELL_DOOR_WEST, CELL_DOOR_ANYWEAPON);
	// "rm_testone_04"
	create_map_cell(16, 21, CELL_SIX_A);
		create_map_door(16, 21, CELL_DOOR_WEST, CELL_DOOR_ANYWEAPON);
	create_map_cell(17, 21, CELL_FOURTEEN_A);
	create_map_cell(18, 21, CELL_SIX_C);
		create_map_door(18, 21, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
	// "rm_areaone_save_01"
	create_map_cell(28, 16, CELL_THREE_A);
		create_map_door(28, 16, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
		create_map_door(28, 16, CELL_DOOR_WEST, CELL_DOOR_ANYWEAPON);
	// "rm_areaone_morphball"
	create_map_cell(15, 21, CELL_TWO_C);
		create_map_door(15, 21, CELL_DOOR_EAST, CELL_DOOR_ANYWEAPON);
}