/// @description Holds additional data that is used by or relevant to the "obj_controller" object.

#region Initializing any macros that are useful/related to obj_controller
#endregion

#region Initializing enumerators that are useful/related to obj_controller
#endregion

#region Initializing any globals that are useful/related to obj_controller

// Stores all the unique ID values for all of the menu structs that have been created and currently exist
// within memory simultaneously; updating, drawing, and processing all other general events that exist within
// each menu--in order from the oldest existing menu instance to the newest, respectively.
global.menuInstances = ds_list_create();

#endregion

#region Global functions related to obj_controller

/// @description A simple function that createds an instance of a menu, but only a single instance of that
/// menu at any given time to prevent accidental duplication. It initializes the newly created menu, adds it
/// to the list of existing menu structs, and the returns the new struct's ID for any use that is required
/// after this function is called by whatever had called it.
/// @param {Function}	struct
function instance_create_menu_struct(_struct){
	// Prevent the menu from being created if it already exists in the menu instance list OR if the struct
	// provided to the function isn't a valid menu struct.
	if (get_menu_struct(_struct) != undefined || !is_menu_struct(_struct)) {return noone;}
	
	// Store the new menu instance into the list that manages existing menus upon said menu's creation. Also
	// returns that instance's "id" values, which allows reference to it specifically during runtime while it
	// is still exists in memory.
	var _instance = instance_create_struct(_struct);
	ds_list_add(global.menuInstances, _instance);
	return _instance;
}

/// @description A simple function that destroys a menu struct; clearing it from memory and also removing its
/// instance ID from the menu management list. However, it will only perform these actions if the supplied
/// struct was found within that list to begin with.
/// @param {Function}	struct
function instance_destroy_menu_struct(_struct){
	var _structIndex = get_menu_struct(_struct);
	if (_structIndex != undefined){
		instance_destroy_struct(global.menuInstances[| _structIndex]);
		ds_list_delete(global.menuInstances, _structIndex);
	}
}

/// @description A simple function that will search through the menu struct list to see if the provided
/// struct index doesn't already currently exist. This is done by linearly going through said list to see
/// if one of the menu object's object_index variable matches up with the provided struct's index. If so,
/// the function returns true. Otherwise, it will return false.
/// @param {Function}	struct
function get_menu_struct(_struct){
	var _length = ds_list_size(global.menuInstances);
	for (var i = 0; i < _length / 2; i++){
		if (global.menuInstances[| i].object_index == _struct ||
			global.menuInstances[| _length - i - 1].object_index == _struct) {return i;}
	}
	return undefined;
}

/// @description A simple function that checks to see if the struct being referenced is a menu struct; 
/// meaning that it inherits from the "par_menu" constructor. OR actually is that "par_menu" struct. In 
/// short, if it is  found in the switch/case statement, the function will return true, and by default it 
/// will return false.
/// @param {Function}	struct
function is_menu_struct(_struct){
	switch(_struct){
		case par_menu:						return true;
		case obj_main_menu:					return true;
		case obj_item_collection_screen:	return true;
		default:							return false;
	}
}

#endregion