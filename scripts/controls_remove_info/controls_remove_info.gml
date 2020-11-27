/// @description Removes data at the desired index and recalculates the positions of the controls for that
/// anchor group.
/// @param index
function controls_remove_info(_index){
	_anchor = controlsAnchor[| _index];

	// Deleting the position data
	var _trueIndex = _index * 2;
	ds_list_delete(controlsPos, _trueIndex);
	ds_list_delete(controlsPos, _trueIndex);
	// Deleting the anchor data
	ds_list_delete(controlsAnchor, _index);
	// Deleting the information data
	_trueIndex = _index * 3;
	ds_list_delete(controlsInfo, _trueIndex);
	ds_list_delete(controlsInfo, _trueIndex);
	ds_list_delete(controlsInfo, _trueIndex);

	// Finally, recalculate the position for the controls using that anchor
	controls_calculate_position(_anchor);
}