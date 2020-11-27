/// @description Handling Transition/State Code

// If the game state isn't currently set to InMenu, delete the menu(s)
if (global.gameState == GameState.InGame){
	instance_destroy(self, false); // Destroy event will not be performed for this case
}

// Handling the existing state if one is currently being executed
if (transition != -1){
	// Don't perform transition if transitionArgs is no longer an array
	if (!is_array(transitionArgs)){
		transition = -1;
		return;
	}
	// Keeps the transition executing until an end case is triggered by the script itself
	transition = script_execute(transition, transitionArgs);
	return;
}

// Execute the menu's given state's code if is set to a script index
if (curState != -1){
	script_execute(curState);
}