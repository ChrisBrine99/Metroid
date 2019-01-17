///scr_shield_collision(destroyProj)
// Handles collision between Samus' projectile and an enemy shield.

var destroyProj;
destroyProj = argument0;

// Collision with an enemy shield
if (instance_exists(obj_enemy_shield)){
	var block = instance_nearest(x, y, obj_enemy_shield);
	if (place_meeting(x + hspd, y + vspd, block)){
		if (audio_is_playing(snd_door2)) audio_stop_sound(snd_door2);
		audio_play_sound(snd_door2, 0, false);
		if (destroyProj){
			canExplode = false;
			instance_destroy(self);
		}
	}
}