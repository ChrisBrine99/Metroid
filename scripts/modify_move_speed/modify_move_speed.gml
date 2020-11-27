/// @description Modifies the CURRENT maximum hspd and vspd (The initial constants remain the same) to the new 
/// values provided. if the modification has to be relative to the current maximum values, it will be added or
/// subtracted as such. Otherwise, it is chanced to the passed values.
/// @param hspdModifier
/// @param vspdModifier
/// @param relative

function modify_move_speed(_hspdModifier, _vspdModifier, _relative){
	if (_relative){
		maxHspd = max(0, maxHspd + _hspdModifier);
		maxVspd = max(0, maxVspd + _vspdModifier);
		return;
	}
	maxHspd = max(0, _hspdModifier);
	maxVspd = max(0, _vspdModifier);
}