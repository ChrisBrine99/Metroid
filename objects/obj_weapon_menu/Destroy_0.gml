/// @description Quick Swapping if the menu isn't open
// You can write your code in this editor

if (global.gameState == GAME_STATE.IN_GAME){
	with(obj_player){
		if (!inMorphball){ // Swapping Beams
			var length, prevIndex;
			length = array_length_1d(isWeaponUnlocked);
			prevIndex = curWeaponIndex;
			for (var i = curWeaponIndex + 1; i <= length; i++){
				// Returning back to the Power Beam
				if (i == length){
					curWeaponIndex = 0;
					fireRateTimer = 0;
					if (missilesEquipped){
						missilesEquipped = false;
						scr_play_sound(snd_missile_select, 0, false, true);
					}
					break;
				}
				// Checking for the next beam/missile that Samus can equip
				if (isWeaponUnlocked[i]){
					curWeaponIndex = i;
					fireRateTimer = 0;
					if ((i == 5 || i == 6) && !missilesEquipped){
						missilesEquipped = true;
						scr_play_sound(snd_missile_select, 0, false, true);
					}
					break;
				}
			}
			// Play the sound for switeching weapons only if the weapon was actually changed
			if (curWeaponIndex != prevIndex){
				scr_play_sound(snd_beam_select, 0, false, true);
			}
		} else{
			// TODO -- Swapping Bombs	
		}
	}
} else{ // Equipping the selected beam/missile/bomb
	var index = menuOptionExt[curOption[X], 0];
	with(obj_player){
		if (!inMorphball){
			if (index != curWeaponIndex){
				curWeaponIndex = index;
				fireRateTimer = 0;
				if ((index == 5 || index == 6) && !missilesEquipped){
					missilesEquipped = true;
					scr_play_sound(snd_missile_select, 0, false, true);
				} else if ((index < 5 || index > 6) && missilesEquipped){
					missilesEquipped = false;
					scr_play_sound(snd_missile_select, 0, false, true);
				}
			}
		} else{
			curBombIndex = index;	
		}
	}
}
// Update the icon on the HUD
with(obj_hud){
	isVisible = true;
	alarm[0] = 1;
}
// Unpause the game's state
global.gameState = GAME_STATE.IN_GAME;