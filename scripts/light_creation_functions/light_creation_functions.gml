/// @description These functions are involved with creating a light source with a ccertain shape. These shapes
/// include circles and rectangles for the moment, but sprites can be used, along with any other shape that can
/// be created within Game Maker's constraints.

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

/// @description Initializes a new rectangular light source. Two of the input colors SHOULD be set to c_black.
/// Otherwise, the light source will look off.
/// @param width
/// @param height
/// @param strength
/// @param TLcolor
/// @param TRcolor
/// @param BLcolor
/// @param BRcolor
function light_create_rectangle(_width, _height, _strength, _TLcolor, _TRcolor, _BLcolor, _BRcolor){
	// Set all of the light's member variables
	drawFunction = draw_light_rectangle;
	size = [_width, _height];
	strength = _strength;
	ds_list_add(colors, _TLcolor, _TRcolor, _BLcolor, _BRcolor);
}