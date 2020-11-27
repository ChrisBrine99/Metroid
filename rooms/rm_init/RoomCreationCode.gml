// Initialize a new random seed on every start up to ensure randomness
randomize();

// Enable the GPU alpha test to discard transparent pixels in the render pipeline
gpu_set_alphatestenable(true);

// All persistent, global objects will be created here
instance_create_depth(0, 0, GLOBAL_DEPTH, obj_controller);
instance_create_depth(0, 0, GLOBAL_DEPTH, obj_effect_handler);

// After intiialization, go to the next room and begin the game
room_goto_next();

// FOR TESTING
show_debug_overlay(true);