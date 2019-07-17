/// @description Remove the light from the ds_list
// You can write your code in this editor

// Find and delete the light source
var length = ds_list_size(global.lightSources);
for (var i = 0; i < length; i++){
	var curInstance = ds_list_find_value(global.lightSources, i);
	if (curInstance == id){
		ds_list_delete(global.lightSources, i);
		break;	
	}
}