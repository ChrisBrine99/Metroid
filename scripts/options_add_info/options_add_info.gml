/// @description Adds an option to the menu's current list of available options. It also takes in information
/// for the options respective information and adds that to its respective lists as well.
/// @param option
/// @param optionInfo
/// @param isActive

function options_add_info(_option, _optionInfo, _isActive){
	// Add information about the option to its respective lists
	ds_list_add(option, _option);
	ds_list_add(optionActive, _isActive);
	ds_list_add(optionPosOffset, 0, 0);

	// Update the total menu size and recalculate the total rows in the menu
	numOptions = ds_list_size(option);
	menuDimensions[Y] = ceil(numOptions / menuDimensions[X]);

	// Finally, add the option information to its list as well
	ds_list_add(info, _optionInfo);
}