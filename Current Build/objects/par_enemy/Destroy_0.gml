/// @description Insert description here
// You can write your code in this editor

if (invulnerable){
	return;	
}

// Only spawn in an item if the enemy is dead (i.e. not the skree exploding)
if (hitpoints <= 0){
	scr_spawn_item_drop();
}

// Destroy the block if the enemy dies while frozen
if (block != 0){
	instance_destroy(block);
}


// Stops the sound from overlapping
if (audio_is_playing(snd_enemy_die)) audio_stop_sound(snd_enemy_die);
audio_play_sound(snd_enemy_die, 0, false);

// Create the enemy dying explosion
instance_create_depth(x, y + (sprite_height / 2),depth - 100, obj_enemy_die);