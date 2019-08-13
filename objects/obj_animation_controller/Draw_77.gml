/// @description Handling animation speeds
// You can write your code in this editor

if (global.gameState != GAME_STATE.IN_GAME){
	return;	
}

var holdTime = (sprite_get_speed(sprite_index) / 60) * global.deltaTime;
imgIndex += imgSpd * holdTime;
if (imgIndex >= sprite_get_number(sprite_index)){
	imgIndex = 0;
	// Trigger the animation end event
	event_perform(ev_other, ev_animation_end);
} else if (imgIndex <= 0){
	imgIndex = 0;	
}