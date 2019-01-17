/// @description Checks Collision
// You can write your code in this editor

var hasCollision, stopMovement;
if (setIndex >= 2) hasCollision = false;
else hasCollision = true;

// Check if the object has gone outside of the camera's view
if (x < global.camX - 16 || y < global.camY - 16 || x > global.camX + global.camWidth || y > global.camY + global.camHeight){
	canExplode = false;
	instance_destroy(self);	
}


// Borrow the basic enemy left/right movement script
scr_enemy_horizontal_movement();
// Borrow the basic enemy up/down movement script
scr_enemy_vertical_movement();

// Wavebeam Movement
if (waveMotion){
	if (direction == 90 || direction == 270)
		hspd = lengthdir_x(12, dir);
	else if (direction == 180 || direction = 0)
		vspd = lengthdir_y(12, dir);
	dir += increment;
}

// Door collision
if (instance_exists(obj_door)){
	var door = instance_nearest(x, y, obj_door);
	if (door != noone){
		if (!door.open){
			if (place_meeting(x + hspd, y + vspd, door)){
				if (setIndex == door.type || door.type == 0){
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
}

// Collision with a destructable block
scr_dblock_collision();

// Collision with an enemy shield
var destroyProj;
if (setIndex < 4) destroyProj = true;
else destroyProj = false;
scr_shield_collision(destroyProj);

// Collision with an emeny
if (instance_exists(par_enemy)){
	var enemy = instance_nearest(x, y, par_enemy);
	// If the enemy is a enemy's projectile, don't bother checking for collision
	if (enemy.hitpoints > 0 && enemy.canMove){
		if (place_meeting(x + hspd, y + vspd, enemy)){
			if (enemy.weakToBeams){
				if (!enemy.hit || setIndex <= 3){
					enemy.hitpoints -= damage;
					enemy.hit = true;
				}
			}
			else if (!enemy.weakToBeams){
				// Remove any damage it could inflict on the enemy
				canExplode = false;
				if (audio_is_playing(snd_door2)) audio_stop_sound(snd_door2);
				audio_play_sound(snd_door2, 0, false);
			}
			// Freeze the enemy is it was hit by the ice beam
			if (setIndex == 1 && !enemy.frozen) enemy.frozen = true;
			// Destroy the beam if it isn't the Plasma Beam
			if (setIndex < 4) instance_destroy(self);
		}
	}
}

// Checking for collision with regular blocks
scr_entity_collision(false, hasCollision, hasCollision);