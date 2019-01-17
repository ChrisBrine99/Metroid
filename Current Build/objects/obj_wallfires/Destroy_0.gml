/// @description Insert description here
// You can write your code in this editor

// Destroy both of the Wallfire's shield
instance_destroy(s);

global.num++;
// If both wallfires have been killed
if (global.num == 2){
	// Set the boss battle event to true and give out a big reward
	global.event[0] = true;
	scr_spawn_reward(obj_small_health_pickup, obj_small_health_pickup, obj_small_health_pickup, obj_large_health_pickup, global.camX + (global.camWidth / 2), global.camY + (global.camHeight / 2), 50);
	// Restart the item room music
	global.curSong = music_itemRoom;
	global.offset = 0;
	with(obj_controller)
		alarm[0] = 1;
	// Reset the global counter
	global.num = 0;
}

// Call the parent's destroy event
event_inherited();