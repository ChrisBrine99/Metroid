/// @descriptionSets the target position for an unlocked camera to move to. This is useful during cutscenes 
/// since the camera is unlocked during them.
/// @param targetX
/// @param targetY

function set_camera_target_position(_targetX, _targetY){
	with(global.controllerID){
		targetPosition[X] = _targetX;
		targetPosition[Y] = _targetY;
	}
}
