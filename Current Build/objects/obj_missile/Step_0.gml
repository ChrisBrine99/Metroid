/// @description Acclerates the missile
// You can write your code in this editor

// Check if the object has gone outside of the camera's view
if (x < global.camX - 16 || y < global.camY - 16 || x > global.camX + global.camWidth || y > global.camY + global.camHeight){
	canExplode = false;
	instance_destroy(self);	
}

// Borrow the basic enemy left/right movement script
scr_enemy_horizontal_movement();
// Borrow the basic enemy up/down movement script
scr_enemy_vertical_movement();

// Door collision
if (instance_exists(obj_door)){
	var door = instance_nearest(x, y, obj_door);
	if (!door.open){
		if (place_meeting(x + hspd, y + vspd, door)){
			if (door.type == 0 || (door.type == 5 && setIndex == 1) || (door.type == 6 && setIndex == 2)){
				audio_play_sound(snd_door, 1, false);
				door.open = true;
			}
			else{
				if (audio_is_playing(snd_door2)) audio_stop_sound(snd_door2);
				audio_play_sound(snd_door2, 1, false);
				canExplode = false;
			}
		}
	}
}

// Collision with a destructable block
scr_dblock_collision();

// Collision with an enemy shield
scr_shield_collision(true);

// Collision with an enemy
if (instance_exists(par_enemy)){
	var enemy = instance_nearest(x, y, par_enemy);
	// If the enemy is an enemy's projectile, don't bother checking for collision
	if (enemy.hitpoints > 0 && enemy.canMove){
		if (place_meeting(x + hspd, y + vspd, enemy)){
			// Only allow the enemy to be hit if they are weak to missiles and/or super missiles
			if ((setIndex == 1 && enemy.weakToMissiles) || (setIndex == 2 && enemy.weakToSMissiles)){
				if (!enemy.hit){
					enemy.hitpoints -= damage;
					enemy.hit = true;
				}
				instance_destroy(self);
			}
			else{
				if (audio_is_playing(snd_door2)) audio_stop_sound(snd_door2);
				audio_play_sound(snd_door2, 0, false);
				canExplode = false;
				instance_destroy(self);
			}
		}
	}
}

// Checking for collision with regular blocks
scr_entity_collision(false, true, true);