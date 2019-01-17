/// @description Playing the desired song and its intro
// You can write your code in this editor

if (global.curSong == curSong){
	return;	
}

// If the song exists
if (global.curSong != -1){
	hasStarted = true;
	// Stop the old song if the global song has changed
	if (curSong != global.curSong){
		if (audio_is_playing(curSong)){
			audio_stop_sound(curSong);	
		}
	}
	// Play the new song
	curSong = global.curSong;
	audio_play_sound(curSong, 0, false);
}
else{ // Stop playing the previous song
	audio_stop_sound(curSong);
	curSong = -1;
}