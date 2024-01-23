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
room_goto(rm_test_main);

/// FOR TESTING
camera_set_target_object(PLAYER, 0, -16);
show_debug_overlay(true);
//audio_debug(true);
//texture_debug_messages(true);
audio_set_linked_object(PLAYER);

/*with(MAP_MANAGER){
	// -- "rm_test01" map cells -- //
	initialize_map_cell(12, 12, 50, -1, [
	{
		direction	:	MAP_DOOR_NORTH,
		color		:	HEX_LIGHT_BLUE
	}
	]);
	initialize_map_cell(13, 12, 54, 4);
	initialize_map_cell(14, 12, 55, -1, [
	{
		direction	:	MAP_DOOR_EAST,
		color		:	HEX_LIGHT_PURPLE
	}
	]);
	initialize_map_cell(12, 13, 43, -1, [
	{
		direction	:	MAP_DOOR_WEST,
		color		:	HEX_LIGHT_BLUE
	}
	]);
	initialize_map_cell(13, 13, 66, 0);
	initialize_map_cell(14, 13, 61, 4, [
	{
		direction	:	MAP_DOOR_EAST,
		color		:	HEX_RED
	}
	]);
	
	// -- "rm_test02" map cells -- //
	initialize_map_cell( 8, 13, 49, 4, [
	{
		direction	:	MAP_DOOR_WEST,
		color		:	HEX_LIGHT_BLUE
	}
	]);
	initialize_map_cell( 9, 13, 54);
	initialize_map_cell(10, 13, 23);
	initialize_map_cell(11, 13, 35, -1, [
	{
		direction	:	MAP_DOOR_EAST,
		color		:	HEX_LIGHT_BLUE
	}
	]);
	initialize_map_cell( 8, 14, 43, -1, [
	{
		direction	:	MAP_DOOR_WEST,
		color		:	HEX_LIGHT_BLUE
	}
	]);
	initialize_map_cell( 9, 14, 64);
}