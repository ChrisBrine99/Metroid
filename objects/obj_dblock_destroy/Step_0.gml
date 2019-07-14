/// @description IFor pausing/unpausing the game
// You can write your code in this editor

if (global.gameState == GAME_STATE.PAUSED){
	image_speed = 0;
	return;	
}
image_speed = 1;