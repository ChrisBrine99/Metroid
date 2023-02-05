// Only calculate the current frame's new wave offset if the game isn't currently paused AND if the liquid actually
// has usable amplitude and frequency values, respectively.
if (/*GAME_CURRENT_STATE == GameState.Paused ||*/ amplitude <= 0 || frequency <= 0) {return;}
y = initialY + round(amplitude * sin(direction));
direction += DELTA_TIME * frequency;