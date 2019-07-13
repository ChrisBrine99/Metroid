/// @description Controlling the Image Speed
// You can write your code in this editor

// Stop the animation whenever the game is paused
if (global.gameState == GAME_STATE.PAUSED){
	image_speed = 0;
	return;
}
image_speed = 1;