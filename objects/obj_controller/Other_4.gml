/// @description Enable the Current Room's View

if (cameraID != -1){ // Only enable the view if a valid camera object exists
	view_enabled = true;
	view_camera[0] = cameraID;
	view_set_visible(0, true);
}