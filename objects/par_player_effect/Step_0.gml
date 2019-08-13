/// @description Controlling the Image Speed
// You can write your code in this editor

// Stop the animation whenever the game is paused
if (global.gameState == GAME_STATE.PAUSED){
	imgSpd = 0;
	return;
}
imgSpd = 1;