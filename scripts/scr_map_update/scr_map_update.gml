/// @description Finds the player's position within the map grid and updates it. (Relative to the starting point)

// Update the player's position rectangle by making it blink
global.blinkTime = scr_update_value_delta(global.blinkTime, -1);
if (global.blinkTime < 0){
	global.blinkTime = global.blinkTimeMax;
	global.isVisible = !global.isVisible;
}

// Always update the position of the player within the room
global.curRoomSector = [floor(obj_player.x / global.camWidth), floor(obj_player.y / global.camHeight)];
// Don't update the map position in a room when the player is frozen (Ex. Warping)
if (global.gameState == GAME_STATE.PAUSED){
	global.prevRoomSector = global.curRoomSector;
	return;
}

// Check if the player has moved between map cells
if (global.curRoomSector != global.prevRoomSector){
	global.mapUncovered[# global.mapPosX, global.mapPosY] = true;
	// Updating the horizontal position of the current map position
	if (global.curRoomSector[X] < global.prevRoomSector[X]){
		global.prevRoomSector[X] = global.curRoomSector[X];
		global.mapPosX--;
	} else if (global.curRoomSector[X] > global.prevRoomSector[X]){
		global.prevRoomSector[X] = global.curRoomSector[X];
		global.mapPosX++;
	}
	// Updating the vertical position of the current map position
	if (global.curRoomSector[Y] < global.prevRoomSector[Y]){
		global.prevRoomSector[Y] = global.curRoomSector[Y];
		global.mapPosY--;
	} else if (global.curRoomSector[Y] > global.prevRoomSector[Y]){
		global.prevRoomSector[Y] = global.curRoomSector[Y];
		global.mapPosY++;
	}
}