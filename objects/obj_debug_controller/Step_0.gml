/// @description Insert description here
// You can write your code in this editor

#region Keyboard Inputs

var keySongSwitch, keyTrigger, keyLifeUp, keyLifeDown;
keySongSwitch = keyboard_check_pressed(ord("M"));		// Switches the current background music
keyTrigger = keyboard_check(vk_control);				// Enables manipulation of player variables
keyLifeUp = keyboard_check_pressed(ord("S"));			// Increases Samus's Energy Tank count
keyLifeDown = keyboard_check_pressed(ord("A"));			// Decreases Samus's Energy Tank count

#endregion

#region Handling the Menu Transition

var isVisible;
isVisible = obj_hud.isVisible;

// Fading the Debug Menu in and out
if (isVisible && !fadeDestroy){
	alpha += 0.1;
	if (alpha > 1){
		alpha = 1;	
	}
} else{
	alpha -= 0.1;
	if (alpha < 0){
		alpha = 0;	
		if (fadeDestroy) {instance_destroy(self);}
	}
}

#endregion

// Preventing function of the Debug Menu when the game is paused
if (global.gameState != GAME_STATE.IN_GAME){
	return;	
}

#region Switching Music Tracks

if (keySongSwitch){
	if (audio_is_playing(global.curSong)){
		switch(global.curSong){
			case music_surface_sr388:
				global.curSong = music_rocky_maridia;
				global.offset = 9.046;
				global.loopLength = 81.399;
				break;
			case music_rocky_maridia:
				global.curSong = music_brinstar;
				global.offset = 0;
				global.loopLength = 53.881;
				break;
			case music_brinstar:
				global.curSong = music_item_room;
				global.offset = 0.809;
				global.loopLength = 40.548;
				break;
			case music_item_room:
				global.curSong = music_unknown0;
				global.offset = 0;
				global.loopLength = 85.719;
				break;
			case music_unknown0:
				global.curSong = music_save_room;
				global.offset = 0;
				global.loopLength = 58.124;
				break;
			case music_save_room:
				global.curSong = music_surface_sr388;
				global.offset = 9.359;
				global.loopLength = 60.51;
				break;
			default:
				global.curSong = -1;
				break;
		}
	}
}

#endregion

#region Manipulating Player Variables

if (keyTrigger){
	with(obj_player){
		if (keyLifeUp){ // Increasing Energy Tanks
			if (maxLives < 12){
				maxLives++;
				curLives++;
			}
		} else if (keyLifeDown){ // Decreasing Energy Tanks
			if (maxLives > 0){
				maxLives--;
				if (curLives > maxLives) {curLives = maxLives;}
			}
		}
	}	
}

#endregion