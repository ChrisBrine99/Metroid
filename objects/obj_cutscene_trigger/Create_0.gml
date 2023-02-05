#region Variable initialization

// Very important variables that allow the cutscene manager singleton to actually be able to perform the
// execution of scenes. The list will store all of the instructions that are used during this trigger's
// cutscene, and the starting index for the cutscene is determined by the value stored in the second
// variable of this pair.
sceneInstructions = ds_list_create();
startingIndex = 0;

// This list stores all of the required events flags and the states they must have in order to determine
// if the cutscene should be available to the player or not. By leaving this list empty, the cutscene will
// be able to play out no matter what at least once.
requiredFlags = ds_list_create();

// This variable pair will store the unique flag ID as well as the target state for that flag's value. If
// the event flag with that ID already has the same state as the "eventTargetState" variable, the cutscene
// trigger will be removed from the game to prevent it from playing multiple times. However, a ctuscene
// can be set to trigger indefinitely if the "eventFlagID" variable is left at a value of "noone".
eventFlagID = noone;
eventTargetState = true;

#endregion

#region Function initialization

/// @description 
/// @param flagID
/// @param targetState
assign_event_flag = function(_flagID, _targetState){
	EVENT_CREATE_FLAG(_flagID, !_targetState);
	eventFlagID = _flagID;
	eventTargetState = _targetState;
}

/// @description 
/// @param flagID
/// @param requiredState
add_required_flag = function(_flagID, _requiredState){
	if (EVENT_GET_FLAG(_flagID) == EVENT_FLAG_INVALID) {EVENT_CREATE_FLAG(_flagID);}
	ds_list_add(requiredFlags, [_flagID, _requiredState]);
}

#endregion