/// @description Create an Optional Explosion Effect

if (object_exists(collideEffect)){
	instance_create_depth(x, y, ENTITY_DEPTH, collideEffect);
}