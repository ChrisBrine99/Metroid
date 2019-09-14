/// @description Insert description here
// You can write your code in this editor

#region Keyboard Inputs

var keySongSwitch, keyTrigger, keyLifeUp, keyLifeDown, keyAllItems;
keySongSwitch = keyboard_check_pressed(ord("M"));		// Switches the current background music
keyTrigger = keyboard_check(vk_control);				// Enables manipulation of player variables
keyLifeUp = keyboard_check_pressed(ord("S"));			// Increases Samus's Energy Tank count
keyLifeDown = keyboard_check_pressed(ord("A"));			// Decreases Samus's Energy Tank count
keyAllItems = keyboard_check_pressed(ord("Q"));			// Gives Samus all of her items

#endregion

#region Handling the Menu Transition

scr_alpha_control_update();

/*var isVisible = obj_hud.isVisible;
if (isVisible){
	destroyOnZero = true;
	if (!fadeDestroy) {fadingIn = true;}
	else {fadingIn = false;}
} else{
	destroyOnZero = false;	
	fadingIn = false;
}*/

#endregion

// Preventing function of the Debug Menu when the game is paused
if (global.gameState == GAME_STATE.PAUSED || global.gameState == GAME_STATE.CUTSCENE){
	fadingIn = false;
	return;	
}
// Fading in the Menu
if (alpha < 1 && !destroyOnZero){
	fadingIn = true;
}

// Variables that are related to keyboard inputs
var createPrompt, message, col, oCol;
createPrompt = false;
message = "";
col = c_white;
oCol = c_gray;

#region Switching Music Tracks

if (keySongSwitch){
	if (keyTrigger){ // Muting/Unmuting the music
		// Create an On Screen Prompt
		createPrompt = true;
		if (obj_controller.playMusic){
			with(obj_controller) {playMusic = false;}
			message = "Music Has Been Muted";
			col = c_red;
			oCol = c_maroon;
		} else{
			if (!audio_is_playing(global.curSong)){
				with(obj_controller) {playMusic = true;}
				// Alter the Prompt's message and color
				message = "Music Has Been Unmuted";
				col = c_lime;
				oCol = c_green;	
			} else{
				createPrompt = false;	
			}
		}
	} else{	// Playing the next song
		if (audio_is_playing(global.curSong)){ // Play the next track in sequential order
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
}

#endregion

#region Manipulating Player Variables

if (keyTrigger){
	with(obj_player){
		if (keyLifeUp){ // Increasing Energy Tanks
			// Create an On Screen Prompt
			createPrompt = true;
			message = "Energy Tank Has Been Added";
			col = c_lime;
			oCol = c_green;
			if (maxLives < 12){
				maxLives++;
				curLives++;
			} else{ // Alter the Prompt's message and color
				message = "Energy Tank Capacity Has Been Reached";
				col = c_red;
				oCol = c_maroon;	
			}
		} else if (keyLifeDown){ // Decreasing Energy Tanks
			// Create an On Screen Prompt
			createPrompt = true;
			message = "Energy Tank Has Been Removed";
			col = c_red;
			oCol = c_maroon;
			if (maxLives > 0){
				maxLives--;
				if (curLives > maxLives){
					curLives = maxLives;
				}
			} else{ // Alter the Prompt's message
				message = "No Energy Tanks Are Left";	
			}
		}
		
		if (keyAllItems){ // Giving Samus all of her items
			// Create an On Screen Prompt
			createPrompt = true;
			message = "Samus Has Been Given All Her Items";
			if (!global.godMode){
				global.godMode = true;
				// Unlock all of Samus's Generic Items (Morphball, Space Jump, Screw Attack, etc.)
				for (var i = 0; i < 12; i++){
					global.item[i] = true;
				}
				alarm[0] = 1;
				// Adjust the maximum jumping height
				jumpSpd = -7;
				// Max out Samus's Missiles, Super Missiles, and Power Bombs
				maxMissiles = 999;
				numMissiles = maxMissiles;
				maxSMissiles = 999;
				numSMissiles = maxSMissiles;
				maxPBombs = 999;
				numPBombs = maxPBombs;
				// Unlock all of Samus's Weapons and Bombs
				var size = array_length_1d(isWeaponUnlocked);
				for (var w = 0; w < size; w++){
					isWeaponUnlocked[w] = true;	
				}
				size = array_length_1d(isBombUnlocked);
				for (var b = 0; b < size; b++){
					isBombUnlocked[b] = true;	
				}
			} else{
				message = "Samus Already Has Everything";
				col = c_red;
				oCol = c_maroon;
			}
		}
	}
}

#endregion

#region Check if the On-Screen Prompt needs to be created

if (createPrompt){
	draw_create_prompt(obj_on_screen_prompt, 3, 21, message, col, oCol, fa_left, 90);	
}

#endregion