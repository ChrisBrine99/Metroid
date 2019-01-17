/// @description Handles the background music and item screen stuff
// You can write your code in this editor

// Keyboard Variables
keyEquipment = keyboard_check_pressed(vk_control);	// For swapping equipment (Missiles, Super Missiles, Power Bombs)
keyBeam = keyboard_check_pressed(vk_shift);			// For swapping the current equipped beam

// Adding to the time that the player has currently played
if (global.hours < 99){
	secondTimer--;
	if (secondTimer <= 0){
		secondTimer = 60;
		// Incrementing seconds
		global.seconds++;
		if (global.seconds >= 60){
			// Reset the seconds
			global.seconds = 0;
			// Incrementing minutes
			global.minutes++;
			if (global.minutes >= 60){
				// Reset the minutes
				global.minutes = 0;
				// Incrementing hours
				global.hours++;
			}
		}
	}
}

// Samus kicking the bucket
if (global.energy == 0 && global.eTanks == 0){
	audio_stop_sound(curSong);
	if (timeToFade > 0){
		if (timeToFade > 80){
			randomize();
			instance_create_depth(obj_samus.x + round(choose(random(-10), random(10))), obj_samus.y + round(choose(random(-20), random(20))), depth, obj_samus_death);	
		}
		timeToFade--;
		if (timeToFade == 0){
			timeToFade = -1;
			scr_create_fade(x, y, c_black, 1, false);
		}
	}
	else{
		// Restart the game once the fade's alpha hits 1
		if (obj_fade.setAlpha == 1){
			room_goto(rm_game_over);
			instance_destroy(self);
			instance_destroy(obj_samus);
		}
	}
	exit;
}

// Starting the game
if (!global.started){
	if (instance_exists(obj_save_platform)){
		if (obj_save_platform.isSaving){
			exit;	
		}
	}
	if (!audio_is_playing(music_intro) && !instance_exists(obj_fade)){
		if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left)){
			// Playing the current room's song
			alarm[0] = 1;
			global.started = true;
			obj_samus.canMove = true;
		}
		if (!hasPlayed){
			hasPlayed = true;
			audio_play_sound(music_intro, 0, false);	
		}
	}
	exit;
}
// Exiting the item collection screen
if (global.itemCollected){
	obj_samus.canMove = false;
	global.isPaused = true;
	if (keyboard_check_pressed(obj_samus.keyShoot) && !audio_is_playing(global.itemTheme)){
		obj_samus.canMove = true;
		global.isPaused = false;
		global.itemCollected = false;
		audio_stop_sound(global.itemTheme);
		audio_resume_all();
		instance_destroy(instance_nearest(obj_samus.x, obj_samus.y, par_item));
	}
	exit;	
}
// Handling the background music
if (curSong != -1 && hasStarted){
	if (!audio_is_playing(curSong)){
		var song = audio_play_sound(curSong, 0, false);
		if (global.offset != 0)
			audio_sound_set_track_position(song, global.offset);
	}
}

// Opening the Pause Menu
if (instance_exists(obj_pause_menu)){
	exit;
}	
else{
	if (keyboard_check_pressed(vk_escape) && !global.isPaused){
		audio_pause_all();
		audio_play_sound(snd_pause, 1, false);
		var obj = instance_create_depth(global.camX, global.camY, depth, obj_pause_menu);
		obj.alpha = 0;
	}
}

// Switching equipment
if (obj_samus.canMove){
	if (keyEquipment){
		if ((global.curEquipmentIndex == 0 && global.maxEquipmentIndex > 0) || global.curEquipmentIndex == 2){
			// Stopping the sound from overlapping
			if (audio_is_playing(snd_equip_select)) audio_stop_sound(snd_equip_select);
			audio_play_sound(snd_equip_select, 0, false);
		}
		if (global.curEquipmentIndex >= global.maxEquipmentIndex){
			global.curEquipmentIndex = 0;
		}
		else{
			global.curEquipmentIndex++;
		}
	}
	// Switching Beams
	if (keyBeam && global.maxBeamIndex > 0){
		showBeamsTimer = 180;
		// Stopping the sound from overlapping
		if (audio_is_playing(snd_beam_select)) audio_stop_sound(snd_beam_select);
		audio_play_sound(snd_beam_select, 0, false);
		if (global.curBeamIndex >= global.maxBeamIndex){
			global.curBeamIndex = 0;
		}
		else{
			global.curBeamIndex++;
		}
	}
}
if (showBeamsTimer > 0){
	showBeamsTimer--;	
}

// Setting the camera
if (view_current == 0)
	camera_apply(view_camera[0]);

// Debug Mode ////////////////////////////////////////////////////////////////////////
if (keyboard_check_pressed(ord("D"))){
	if (!global.debug){
		global.maxEquipmentIndex = 3;
		global.debug = true;
		par_block.visible = true;
	}
	else{
		global.maxEquipmentIndex = 3;
		if (global.pBombsMax == 0){
			global.maxEquipmentIndex = 2;
			if (global.sMissilesMax == 0){
				global.maxEquipmentIndex = 1;
				if (global.missilesMax == 0)
					global.maxEquipmentIndex = 0;
			}
		}
		room_speed = 60;
		global.debug = false;
	}
}

if (global.debug){
	// Switching Gravity
	if (keyboard_check_pressed(ord("G"))){
		if (!obj_samus.inMorphball){
			displayTxt = "Gravity Switched";
			displayTimer = displayTimerMax;
			if (obj_samus.gravDir == 90)
				obj_samus.gravDir = 270;
			else
				obj_samus.gravDir = 90;
		}
	}
	// Refilling all of Samus's energy
	if (keyboard_check_pressed(ord("F"))){
		displayTxt = "Energy Maxed Out";
		displayTimer = displayTimerMax;
		global.energy = 99;
		global.eTanks = global.eTanksMax;
	}
	// Refilling all of Samus's ammo
	if (keyboard_check_pressed(ord("R"))){
		displayTxt = "All Ammo Replenished";
		displayTimer = displayTimerMax;
		global.missiles = global.missilesMax;
		global.sMissiles = global.sMissilesMax;
		global.pBombs = global.pBombsMax;
	}
	// Giving Samus an Energy Tank
	if (global.eTanksMax < 12){
		if (keyboard_check_pressed(ord("1"))){
			displayTxt = "Energy Tanks Increased";
			displayTimer = displayTimerMax;
			global.eTanksMax++;
			global.eTanks = global.eTanksMax;
			global.energy = 99;
		}
	}
	// Giving Samus 5 Missiles
	if (global.missilesMax < 250){
		if (keyboard_check_pressed(ord("2"))){
			displayTxt = "Missiles Increased by 5";
			displayTimer = displayTimerMax;
			global.missilesMax += 5;
			global.missiles += 5;
		}
	}
	// Giving Samus 2 Super Missiles
	if (global.sMissilesMax < 50){
		if (keyboard_check_pressed(ord("3"))){
			displayTxt = "Super Missiles Increased by 2";
			displayTimer = displayTimerMax;
			global.sMissilesMax += 2;
			global.sMissiles += 2;
		}
	}
	// Giving Samus 2 Power Bomb
	if (global.pBombsMax < 50){
		if (keyboard_check_pressed(ord("4"))){
			displayTxt = "Power Bombs Increased by 2";
			displayTimer = displayTimerMax;
			global.pBombsMax += 2;
			global.pBombs += 2;
		}
	}
	// Activating God Mode
	if (keyboard_check_pressed(ord("5"))){
		if (!godMode){
			displayTxt = "God Mode Activated";
			godMode = true;
			// Activating the morphball powerups
			global.morphball = true;
			global.bombs = true;
			global.spiderBall = true;
			global.springBall = true;
			// Activating the jumping powerups
			global.highJump = true;
			obj_samus.jumpSpd = -7.4;
			global.spaceJump = true;
			global.screwAttack = true;
			// Activating all the beams
			global.iceBeam = true;
			global.waveBeam = true;
			global.spazerBeam = true;
			global.plasmaBeam = true;
			global.maxBeamIndex = 4;
			// Activating the varia and gravity suit
			global.variaSuit = true;
			global.gravitySuit = true;
			with(obj_samus)
				scr_set_sprite_gravity();
		}
		else{
			displayTxt = "God Mode Deactivated";
			godMode = false;
			// Deactivating the morphball powerups
			global.morphball = false;
			global.bombs = false;
			global.spiderBall = false;
			global.springBall = false;
			// Deactivating the jumping powerups
			global.highJump = false;
			obj_samus.jumpSpd = -5.5;
			global.spaceJump = false;
			global.screwAttack = false;
			// Dectivating all the beams
			global.iceBeam = false;
			global.waveBeam = false;
			global.spazerBeam = false;
			global.plasmaBeam = false;
			global.maxBeamIndex = 0;
			// Deactivating the varia and gravity suit
			global.variaSuit = false;
			global.gravitySuit = false;
			global.damageRes = 1;
			with(obj_samus)
				scr_set_sprite_power();
			global.curBeamIndex = 0;
		}
		displayTimer = displayTimerMax;
	}
	
	// Slowing the game down for testing
	if (keyboard_check_pressed(ord("S"))){
		if (room_speed == 60)
			room_speed = 5;
		else
			room_speed = 60;
	}
}
//////////////////////////////////////////////////////////////////////////////////////