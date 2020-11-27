/// @description Sets the entity's maximum hitpoints to a spefcified value. Optionally, the hitpoints can be set
/// to the maximum value. However, if hitpoints are greater than the maximum after the change, they will be set
/// to that maximum value. Setting relative will increase or decrease the current maximum by the specified value. 
/// @param maxHitpoints
/// @param restoreHealth
/// @param relative

function set_max_hitpoints(_maxHitpoints, _restoreHealth, _relative) {
	maxHitpoints = _relative ? maxHitpoints + _maxHitpoints : _maxHitpoints;
	if (_restoreHealth || hitpoints > maxHitpoints){ // Optional health restore
		hitpoints = maxHitpoints;
	}
}