// In order to check where the Gawron is relative to the current bounds of the viewport within the room, the
// camera will need to have its current x and y positions retrieved; as well as its current dimensions. This is
// done by going into the "obj_camera" struct and referencing the camera is is utilizing to render the viewport.
var _camX		= 0;
var _camY		= 0;
var _camWidth	= 0;
var _camHeight	= 0;
with(CAMERA){
	_camX		= camera_get_view_x(camera);
	_camY		= camera_get_view_y(camera);
	_camWidth	= camera_get_view_width(camera);
	_camHeight	= camera_get_view_height(camera);
}

// Check if the Gawron has exceeded the rendering limit boundaries of the screen. If it hasn't, it will remain
// active despite being outside of the current view. Otherwise, it is destroyed.
if (entity_is_on_screen(_camX, _camY, _camWidth, _camHeight))
	return;
stateFlags |= ENTT_DESTROYED;
visible		= false;