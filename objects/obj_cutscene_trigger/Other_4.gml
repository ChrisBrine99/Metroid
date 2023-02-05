// At the start up of the room, the trigger's event flag (If it actually has one assigned to it) is checked
// to see if its current value matches the trigger's target state variable's value. If it does match, the
// trigger will be deleted since the cutscene is no longer needed.
if (eventFlagID != noone && EVENT_GET_FLAG(eventFlagID) == eventTargetState){
	instance_destroy(self);
	return;
}

// If the cutscene's paired event flag isn't currently set to its required state, (Or it doesn't have an event
// flag paired with it) the flags that are required for this trigger to exist are looped through and checked
// to see if their current states patch the needed states stored within this list. If they all match up, the
// trigger will not be deleted since the cutscene is allowed to be played. Otherwise, the trigger is deleted
// until all the required conditions are met.
var _length, _flag;
_length = ds_list_size(requiredFlags);
for (var i = 0; i < _length; i++){
	_flag = requiredFlags[| i];
	if (!is_undefined(_flag) && EVENT_GET_FLAG(_flag[0]) != _flag[1]){
		instance_destroy(self);
		break;
	}
}