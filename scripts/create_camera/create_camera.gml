/// @description Creates the camera object that allows the game to be viewed through its window port. Otherwise,
/// the game would just be a black, empty square and that's no fun.
/// @param scale

function create_camera(_scale){
	if (cameraID == -1){ // Only create the camera if it doesn't current exist
		cameraID = camera_create();
		camera_set_view_size(cameraID, WINDOW_WIDTH, WINDOW_HEIGHT);
		surface_resize(application_surface, WINDOW_WIDTH, WINDOW_HEIGHT);
		camera_set_view_mat(cameraID, matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0));
		camera_set_proj_mat(cameraID, matrix_build_projection_ortho(WINDOW_WIDTH, WINDOW_HEIGHT, 1, 10000));
		set_window_size(_scale);
	}
}
