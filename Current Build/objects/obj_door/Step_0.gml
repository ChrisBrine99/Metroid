/// @description Opening the Door
// You can write your code in this editor

if (instance_exists(obj_fade)){
	if (obj_fade.doorFade){
		return;	
	}
}

if (open){
	image_speed = 0.75;
}

if (closing){
	if (image_index < 1){
		image_index = 0;
		image_speed = 0;
		closing = false;
	}
	else{
		if (!audio_is_playing(snd_door)){
			audio_play_sound(snd_door, 1, false);	
		}
		image_speed = -0.75;	
	}
}

// Stuff for the disabled door
if (type == 8){
	// Change the door to open when all enemies have been defeated
	if (instance_number(par_enemy) <= 0){
		type = 0;
		sprite_index = spr_blue_door;
	}
}