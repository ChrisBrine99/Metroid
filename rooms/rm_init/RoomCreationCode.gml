// 
gpu_set_alphatestenable(true);
application_surface_draw_enable(false);

// 
instance_create_singleton_struct(obj_camera);
instance_create_singleton_struct(obj_music_handler);
instance_create_singleton_struct(obj_effect_handler);
instance_create_singleton_struct(obj_cutscene_manager);
instance_create_singleton_struct(obj_textbox_handler);
instance_create_singleton_struct(obj_control_info);
instance_create_singleton_struct(obj_screen_fade);
instance_create_singleton_object(0, 0, obj_controller);
instance_create_singleton_object(0, 0, obj_player);
instance_create_singleton_object(0, 0, obj_controller);
with(PLAYER) {initialize(state_intro);}

// 
game_load_settings();

// Start the camera with the player in the center of the view (if possible given the view locking)
camera_set_position(PLAYER.x, PLAYER.y);
camera_set_state(STATE_FOLLOW_OBJECT, [PLAYER, 6, 10]);

// By default, all keyboard icons are set to keyboard. (Since this is the PC version...) This function will
// initialize the control info icons to that control method.
//CONTROL_INFO.initialize_input_icons();

// Finally, once all the initialization has completed, move into the first true room of the game.
room_goto(rm_test01);

/// FOR TESTING
show_debug_overlay(true);
//audio_debug(true);
texture_debug_messages(true);
audio_set_linked_object(PLAYER);