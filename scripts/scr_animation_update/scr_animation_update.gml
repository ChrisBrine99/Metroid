/// @description Updates an object's current animation.
/// NOTE -- This must be placed in the post-draw event of an object in order to function correctly

// Only execute the script if the game isn't paused or the code is being executed in the post-draw event
if (global.gameState == GAME_STATE.PAUSED || event_number != ev_draw_post){
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