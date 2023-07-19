/// @description A simple function that makes use of the three state variables found within most objects that
/// use some form of a state machine for their function and logic; updating the function that is called from
/// the next frame onward within the object.
/// @param {Function}	nextState
function object_set_next_state(_nextState){
	nextState = _nextState;
	lastState = curState;
}

/// @description An extension of GameMaker's built-in "instance_create_depth" function that will prevent the
/// creation of multiple singleton objects (Ex. The controller and player objects). All objects being created
/// should use this function instead of the engine's defaults to avoid any bugs or issues.
/// @param {Real}			x		The x position the object will be created at in the current room.
/// @param {Real}			y		The y position the object will be created at in the current room.
/// @param {Asset.GMObject}	object	Asset index for the object that will be created.
/// @param {Real}			depth	Optional depth level to place the object at. (Default = 30)
function instance_create_object(_x, _y, _object, _depth = 30){
	if (!singleton_instance_exists(_object)) {return instance_create_depth(_x, _y, _depth, _object);}
	return noone;
}

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

/// @description Destroys any non-singleton object. If the object in question is that of a singleton, this
/// function will not destroy the object and instead perform none of its deletion logic.
/// @param {Id.Instance}	instance		The id of the object that will be destroyed.
/// @param {Bool}			performEvents	Determines if the "Destroy" event should be called.
function instance_destroy_object(_instance, _performEvents = true){
	if (singleton_instance_exists(_instance.object_index)) {return;}
	instance_destroy(_instance, _performEvents);
}