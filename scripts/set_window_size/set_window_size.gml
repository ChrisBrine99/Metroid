/// @description Sets the window's size based on a scaling factor relative to its currently set aspect ratio.
/// @param scale

function set_window_size(_scale){
	var _windowDimensions = [camera_get_view_width(cameraID) * floor(_scale), camera_get_view_height(cameraID) * floor(_scale)];
	// After calculating the scale value for the window's dimensions, set the position and resize
	window_set_position(round((display_get_width() - _windowDimensions[X]) / 2), round((display_get_height() - _windowDimensions[Y]) / 2));
	window_set_size(_windowDimensions[X], _windowDimensions[Y]);
	// Finally, update the GUI scaling to match the window's new scale
	display_set_gui_maximize(_scale, _scale, 0, 0);
}
