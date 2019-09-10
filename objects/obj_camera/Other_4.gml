/// @description Setup the camera
// You can write your code in this editor

// Enabling the view
view_enabled = true;
view_set_visible(0, true);

// Creating a projection matrix for the camera
var vm, pm;
vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
pm = matrix_build_projection_ortho(global.camWidth, global.camHeight, 1, 10000);
// Setting the camera's view matrix and projection matrix
camera_set_view_mat(camera, vm);
camera_set_proj_mat(camera, pm);
// Setting the current view to the camera
view_camera[0] = camera;