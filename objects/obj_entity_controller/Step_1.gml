/// @description Checking if the Entity Should Be Frozen Or Not
// You can write your code in this editor

if (global.gameState != GAME_STATE.IN_GAME){ // Freezing the entity
	image_speed = 0;
	canMove = false;
} else{ // Unfreezing the entity
	canMove = true;	
	// Reset the hspd penalty
	hspdPenalty = 0;
}