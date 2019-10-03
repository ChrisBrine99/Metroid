/// @description Update the delta time
// You can write your code in this editor

room_speed = global.oVideo[3];
global.deltaTime = get_delta_time();
// Stops weird issues from happening whenever V-sync is enabled
if (global.deltaTime >= 0.98 && global.deltaTime <= 1.02){
	global.deltaTime = 1;	
}