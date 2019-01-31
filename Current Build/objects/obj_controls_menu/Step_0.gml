/// @description Insert description here
// You can write your code in this editor

// Call the parent object's step event
if (secondKeyPressed){
	if (timer < 0){
		event_inherited();
		if (keyRight){
			audio_play_sound(snd_beam_select, 1, false);
			curOption += 5;
			if (curOption > 14) 
				curOption -= 15;
		}
		if (keyLeft){
			audio_play_sound(snd_beam_select, 1, false);
			if (curOption >= 15)
				curOption -= (curOption - 14);
			curOption -= 5;
			if (curOption < 0)
				curOption += 15;
		}
	}
	else timer--;
	// Reset the timer once a key has been pressed
	if (selectedOption == curOption) timer = 3;
}

if (selectedOption == curOption){
	if (timer <= 0){
		if (keyboard_check_pressed(global.key[curOption])){
			secondKeyPressed = true;
			selectedOption = -1;
			timer = 3;
			return;
		}
		if (keyboard_check_pressed(vk_anykey)){
			var key, duplicate, otherKey;
			key = keyboard_lastkey;
			duplicate = false;
			otherKey = vk_nokey;
			if (selectedOption < 10){ // Checking for duplicates for the in-game controls
				for (var i = 0; i < 10; i++){
					if (global.key[i] == key){
						otherKey = i;
						i = array_length_1d(global.key);
						duplicate = true;
						continue;
					}
				}
			}
			else{ // Checking for duplicates for the menu controls
				for (var i = selectedOption; i < array_length_1d(global.key); i++){
					if (global.key[i] == key){
						otherKey = i;
						i = array_length_1d(global.key);
						duplicate = true;
						continue;
					}	
				}
			}
			// Only change the keybinding if the key isn't a duplicate
			if (!duplicate){
				global.key[selectedOption] = key;
			}
			else{
				global.key[otherKey] = global.key[selectedOption];
				global.key[selectedOption] = key;
			}
			secondKeyPressed = true;
			selectedOption = -1;
			timer = 3;
		}
		return;
	}
	prevKey = global.key[selectedOption];
	secondKeyPressed = false;
	timer--;
}
else{
	if (secAlpha > 0)
		secAlpha -= 0.2;
}