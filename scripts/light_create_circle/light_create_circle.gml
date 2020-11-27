/// @description Initializes a new circle light.
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color

function light_create_circle(_radiusX, _radiusY, _strength, _color){
	// Set all of the light's member variables
	drawFunction = draw_light_circle;
	size = [_radiusX, _radiusY];
	strength = _strength;
	ds_list_add(colors, _color, c_black);
}