/// @description Sets the currently executed state to a new function index. Also stores the last state within 
/// its own variable for easy referece and comparison. If the passed in function is identical to the current 
/// state, don't change the state.
/// @param newState

function set_cur_state(_newState){
	if (_newState != curState){
		lastState = curState;
		curState = _newState;
	}
}