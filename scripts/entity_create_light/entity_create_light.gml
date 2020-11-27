/// @description Creates a circular light for the entity's ambLight variable. From there, the size, color, 
/// strength, and offset position are all applied to said light.
/// @param offsetX
/// @param offsetY
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color

function entity_create_light(_offsetX, _offsetY, _radiusX, _radiusY, _strength, _color) {
	ambLight = instance_create_depth(x + _offsetX, y + _offsetY, ENTITY_DEPTH, obj_light);
	with(ambLight){ // Apply all the entity's settings to the light itself
		light_create_circle(_radiusX, _radiusY, _strength, _color);
	}
	lightPosition = [_offsetX, _offsetY];
}