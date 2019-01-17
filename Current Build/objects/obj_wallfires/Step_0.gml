/// @description Insert description here
// You can write your code in this editor

// Don't activate the boss fight if the wallfires aren't active yet
if (!isActive){
	y += 0.5;
	if (y >= 96){
		y = 96;
		offset--;
		if (offset <= 0){
			hitpoints = 35;
			isActive = true;
			// Start the boss fight music
			global.curSong = music_boss1;
			global.offset = 4.408;
			with(obj_controller)
				alarm[0] = 1;
		}
	}
	return;
}

scr_wallfires();