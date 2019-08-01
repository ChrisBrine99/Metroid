/// @description Removes a value from any point in the given ds_list. Returns false if the list doesn't exist
/// so error messages can be used to inform the user of what happened.
/// @param ds_list_id

var ds_list_id, length;
ds_list_id = argument0;
length = 0;

// Check if the given ds_list actually exists
if (!ds_exists(ds_list_id, ds_type_list)){
	return false;
} else{
	// Find and delete the given instance from the given list
	length = ds_list_size(ds_list_id);
	for (var i = 0; i < length; i++){
		var curInstance = ds_list_find_value(ds_list_id, i);
		if (curInstance == id){
			ds_list_delete(ds_list_id, i);
			break;
		}
	}
	return true;
}