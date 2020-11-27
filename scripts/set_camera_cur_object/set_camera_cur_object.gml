/// @description Sets the curObject variable to the ID for the object the camera will follow. Instead of 
/// instantly locking on, however, the camera will instead set a flag that enabled the camera to smoothly 
/// reach whatever position the followed object is at before resetting to default movement.
/// @param objectID

function set_camera_cur_object(_objectID){
	with(global.controllerID){
		set_camera_target_position(_objectID.x, _objectID.y);
		curObject = _objectID;
		newObjectSet = true;
	}
}
