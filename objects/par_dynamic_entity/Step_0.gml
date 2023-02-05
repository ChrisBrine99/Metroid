// Execute the entity's current state if there is a valid function index within the variable.
if (GAME_CURRENT_STATE != GameState.Paused && curState != NO_STATE) {curState();}