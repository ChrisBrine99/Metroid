// 
gpu_set_alphatestenable(true);
application_surface_draw_enable(false);

// Instantiate all singleton objects and structs here. These will exist for the entire duration of the game, and
// will prevent any from being destroyed until the game triggers its closing event through "game_end".
instance_create_singleton_struct(obj_camera);
instance_create_singleton_struct(obj_music_handler);
instance_create_singleton_struct(obj_effect_handler);
instance_create_singleton_struct(obj_cutscene_manager);
//instance_create_singleton_struct(obj_textbox_handler);
//instance_create_singleton_struct(obj_control_info);
instance_create_singleton_struct(obj_game_hud);
instance_create_singleton_struct(obj_screen_fade);
instance_create_singleton_struct(obj_debugger);
instance_create_singleton_object(0, 0, obj_controller);
instance_create_singleton_object(0, 0, obj_player);
instance_create_singleton_object(0, 0, obj_controller);
with(PLAYER) {initialize(state_intro);} // FOR TESTING PURPOSES

// Attempt to load in the game's settings from a saved .ini file. If no file currently exists, default settings
// will be used instead.
game_load_settings();

// By default, all keyboard icons are set to keyboard. (Since this is the PC version...) This function will
// initialize the control info icons to that control method.
//CONTROL_INFO.initialize_input_icons();

// Finally, once all the initialization has completed, move into the first true room of the game.
room_goto(rm_test01);

/// FOR TESTING
camera_set_target_object(PLAYER, 0, -16);
show_debug_overlay(true);
//audio_debug(true);
texture_debug_messages(true);
audio_set_linked_object(PLAYER);