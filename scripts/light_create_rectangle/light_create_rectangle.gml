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