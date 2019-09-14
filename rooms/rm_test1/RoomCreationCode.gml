// Code used to assign what background music is being played at the moment. The offset is what to start the song
// on when it loops around to the beginning.
global.curSong = music_brinstar;
global.offset = 0;
global.loopLength = 53.881;

// Edit the bloom and lighting system settings
if (global.lightingID != noone){
	with(global.lightingID){
		if (object_index == obj_lighting){
			curLightingCol = c_ltgray;
		}
	}
}
if (global.bloomID != noone){
	with(global.bloomID){
		if (object_index == obj_bloom){
			bloomThreshold = 0.5;
			blurSteps = 2;
			sigma = 0.1;
		}
	}
}