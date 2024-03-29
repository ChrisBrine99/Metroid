// A variable that uses an ID'ing system that works very similarly to how GameMaker's own instance ID system
// functions; giving each new instance of a struct (So long as they inherit from "base_struct" found below) a
// unique number that it can be identified with.
global.structID = 1000000;

// A list that manages the pointers for all struct instances created during the game's runtime. It will allow
// reference to these structs through their unique ID values; much like what Game Maker does with its objects.
global.structs = ds_list_create();

/// @description A basic struct that all others must inherit from (So long as they use the "constructor" moniker
/// and aren't created and assigned to local variables within an object/struct upon said object/struct's creation).
/// This means all structs will have their own initialize and cleanup functions regardless of if they inherit
/// them for their own use or not.
/// @param {Real} index		Unique value generated by GML during compilation that represents this struct asset.
function base_struct(_index) constructor{
	id = global.structID;
	object_index = _index;

	initialize = function(){}
	cleanup = function(){}
}

/// @description Creates a new struct object in a way that mimics how GameMaker creates and handles its own
/// object instances; storing a unique id indentifier value to a struct upon creation for easy reference of
/// a single instance or instances of that struct. Singleton structs will not be able to be created by this
/// function if an instance of them already exists in the game.
/// @param {Struct}	struct	The struct object to be instantiated by GameMaker.
function instance_create_struct(_struct){
	if (!singleton_instance_exists(_struct)){
		var _instance = new _struct(_struct);
		_instance.initialize(); // Every instance overrides this function from the base struct.
		ds_list_add(global.structs, _instance);
		global.structID++;
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

/// @description A function that mimics how GameMaker's own "instance_destroy" function works, but focuses on
/// the deletion of structs that exist within the game currently. Singleton structs are not allowed to be
/// deleted by this function; as they generally exist for the entire duration of the game's runtime.
/// @param {Struct}	instance	The struct instance that will be marked for deletion by GameMaker's garbage collector.
function instance_destroy_struct(_instance){
	var _index = ds_list_find_index(global.structs, _instance);
	if (_index == -1 || singleton_instance_exists(_instance.object_index)) 
			return;
	ds_list_delete(global.structs, _index);
	_instance.cleanup();
	delete _instance;
}

/// @description Finds the struct instance with the designated ID given as the function's argument; returning
/// the reference to that struct so the variables and method within can be referenced if required. If a struct
/// with that ID cannot be found, the function will return "noone" to signify an invalid instance.
/// @param {Id.Instance}	id
function instance_find_struct(_id){
	var _struct = noone;
	var _length = ds_list_size(global.structs);
	for (var i = 0; i < _length * 0.5; i++){
		_struct = global.structs[| i];
		if (_struct.id == _id) {return _struct;}
		_struct = global.structs[| _length - i];
		if (_struct.id == _id) {return _struct;}
	}
	return noone; // Default value returned if no instance with that ID value was found
}

/// @description Finds where the desired struct instance is placed within the management list for all currently
/// existing instances of structs within the game. If no instance is found, the function will return a -1 to
/// signify no valid index was found.
/// @param {Id.Instance}	id
function instance_find_struct_index(_id){
	var _struct = noone;
	var _length = ds_list_size(global.structs);
	for (var i = 0; i < _length * 0.5; i++){
		_struct = global.structs[| i];
		if (_struct.id == _id) {return i;}
		_struct = global.structs[| _length - i];
		if (_struct.id == _id) {return _length - i;}
	}
	return -1;
}