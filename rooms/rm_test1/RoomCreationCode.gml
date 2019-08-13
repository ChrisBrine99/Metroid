// Code used to assign what background music is being played at the moment. The offset is what to start the song
// on when it loops around to the beginning.
global.curSong = music_brinstar;
global.offset = 0;
global.loopLength = 53.881;

// Edit the bloom and lighting system settings
if (instance_exists(obj_lighting)){
	with(obj_lighting){
		curLightingCol = c_ltgray;
	}
}
if (instance_exists(obj_bloom)){
	with(obj_bloom){
		bloomThreshold = 0.5;
		blurSteps = 2;
		sigma = 0.1;
	}
}