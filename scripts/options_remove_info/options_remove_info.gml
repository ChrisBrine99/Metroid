/// @description Removes option data from its respective ds_lists as well as its information from that ds_list.
/// @param index

function options_remove_info(_index){
	var _index2D = (_index * 2);
	// Remove the option's string, position offset data, and its active state
	ds_list_delete(option, _index);
	ds_list_delete(optionActive, _index);
	ds_list_delete(optionPosOffset, _index2D);
	ds_list_delete(optionPosOffset, _index2D + 1);

	// Update the total menu size and recalculate the total rows in the menu
	numOptions = ds_list_size(option);
	menuDimensions[Y] = floor(numOptions / menuDimensions[X]);

	// Finally, remove option information data from its ds_list
	ds_list_delete(info, _index);
}