/// @description Performs almost identically to the "instance_create_object" function with the added functionality
/// of adding the object in question to the singleton object data structure if no instance of the object has
/// previously been added to said data; after which no copies of the object can be created by either this or
/// "instance_create_object".
/// @param {Real}			x		The x position the object will be created at in the current room.
/// @param {Real}			y		The y position the object will be created at in the current room.
/// @param {Asset.GMObject}	object	Asset index for the object that will be created.
/// @param {Real}			depth	Optional depth level to place the object at. (Default = 30)
function instance_create_singleton_object(_x, _y, _object, _depth = 30){
	if (!singleton_instance_exists(_object)){
		var _instance = instance_create_depth(_x, _y, _depth, _object);
		ds_map_add(global.sInstances, _object, _instance);
		return _instance;
	}
	return noone;
}

/// @description Creates a struct that is deemed a singleton, which means calling this function again in an
/// attempt to intialize another instance of this struct will cause it to create nothing; the same applying
/// to "instance_create_struct" if used instead.
/// @param {Struct}	struct	The struct object that will be created and assigned as a singleton to prevent its duplication.
function instance_create_singleton_struct(_struct){
	var _instance = instance_create_struct(_struct);
	if (_instance != noone) {ds_map_add(global.sInstances, _struct, _instance);}
}

/// @description A simple function that will check to see if the instance being created for an object is an 
/// already existing singleton object; returning true if one already exists and false if it doesn't exist OR
/// it's not a singleton object to begin with.
/// @param {Any}	object	The object index to check against the map of already existing singletons.
function singleton_instance_exists(_object){
	var _value = ds_map_find_value(global.sInstances, _object);
	if (is_undefined(_value)) {return false;}
	return true;
}