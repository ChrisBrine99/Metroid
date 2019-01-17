/// @description Playing the sounds when the timer reaches zero
// You can write your code in this editor

// The Thunder Sound Effect
thunderTimer--;
if (thunderTimer <= 0){
	thunderTimer = 45 + round(random(1250));
	audio_play_sound(snd_thunder, 0, false);
	global.curLightingCol = origCol;
}

// Making the screen flash yellow
if (thunderTimer < 15){
	var flash = choose(false, true);
	if (flash)
		global.curLightingCol = c_blue;
	else
		global.curLightingCol = origCol;
}