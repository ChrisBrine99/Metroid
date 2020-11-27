/// @description Update Delta Time and Camera Position

// Update camera's position
update_camera_position();

// Calculate this frame's delta time
global.deltaTime = (delta_time / 1000000) * global.targetFPS;