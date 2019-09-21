/// @description Handling Music Playback/Pausing the Game
// You can write your code in this editor

#region Keyboard Input(s)

var keyPause, keyDebug, keyDebug2;
keyPause = keyboard_check_pressed(vk_escape);
keyDebug = keyboard_check_pressed(ord("D"));
keyDebug2 = keyboard_check(vk_lcontrol);

#endregion

#region Handling Background Music

if (song != -1){
	var curPos = audio_sound_get_track_position(song);
	if (curPos > totalLength){
		audio_sound_set_track_position(song, curPos - global.loopLength);
	}
	// Checking if the song has been changed while in the same room
	if (global.curSong != curSong || !playMusic){
		// Stopping the previous song
		if (audio_sound_get_gain(curSong) == 0){
			audio_stop_sound(curSong);
			song = -1;
			fadingOut = false;
		} else if (!fadingOut){ // Starting the song's fade out
			audio_sound_gain(curSong, 0, fadeTime);	
			fadingOut = true;
		}
	}
} else{ // Play the new song
	if (playMusic){
		if (global.curSong != -1){
			curSong = global.curSong;
			song = audio_play_sound(curSong, 1000, false);
			// Set the sound's volume to 0 and slowly fade it in over one second
			audio_sound_gain(curSong, 0, 0);
			audio_sound_gain(curSong, scr_volume_type(curSong), fadeTime);
			// Setting up the looping length variables
			totalLength = global.loopLength + global.offset;
		}
	}
}

#endregion

#region Opening the Pause Menu/Debug Menu

if (keyPause){
	// TODO -- Create the Pause Menu here	
}

if (!global.debugMode){
	// Opening a streamlined debug menu
	if (keyDebug2 && keyDebug){
		showStreamlinedDebug = !showStreamlinedDebug;
	}
	show_debug_overlay(showStreamlinedDebug);
}

// Opening the full debug menu
if (keyDebug && !keyDebug2){
	if (instance_exists(obj_debug_controller)){ // Disabling Debug Mode
		with(obj_debug_controller){
			fadingIn = false;
			destroyOnZero = true;
		}
		global.debugMode = false;
	} else{	// Enabling Debug Mode
		instance_create_depth(0, 0, 5, obj_debug_controller);
		global.debugMode = true;
	}
}

#endregion