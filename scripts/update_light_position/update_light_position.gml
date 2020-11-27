/// @description Updates the position of an object's ambient light source. This should be called in the end step
/// event for whatever object is calling this script.
/// @param lightID
/// @param xPos
/// @param yPos

function update_light_position(_lightID, _xPos, _yPos){
	if (_lightID != noone){
		_lightID.x = _xPos;
		_lightID.y = _yPos;
	}
}