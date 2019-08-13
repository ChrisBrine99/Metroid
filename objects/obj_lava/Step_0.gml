/// @description Pulse the light emitter with the lava tiles
// You can write your code in this editor


if (global.gameState == GAME_STATE.PAUSED){
	imgSpd = 0;
	return;
}
imgSpd = 1;

pulseTime = scr_update_value_delta(pulseTime, -1);
if (pulseTime <= 0){
	if (decIntensity){
		intensity -= 0.075;
		// Check if the intensity should be swapped
		if (intensity <= 1 - (0.075 * 4)) {decIntensity = false;}
	} else{
		intensity += 0.075;
		// Check if the intensity should be swapped
		if (intensity >= 1) {decIntensity = true;}
	}
	// Move the ambient light accordingly
	var newPos, newYRad;
	newPos = y - (origin * intensity);
	newYRad = origin * intensity;
	with(ambLight){
		y = newPos;
		yRad = newYRad;
	}
	// Reset the pulse timer
	pulseTime = 12;
}