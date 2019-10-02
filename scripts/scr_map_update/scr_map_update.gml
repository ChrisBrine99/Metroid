/// @description Finds the player's position within the map grid and updates it. (Relative to the starting point)

// Always update the position of the player within the room
curRoomSector = [floor(obj_player.x / global.camWidth), floor(obj_player.y / global.camHeight)];
// Don't update the map position in a room when the player is frozen (Ex. Warping)
if (global.gameState == GAME_STATE.PAUSED){
	prevRoomSector = curRoomSector;
	return;
}

if (curRoomSector != prevRoomSector){
	global.mapUncovered[# global.mapPosX, global.mapPosY] = true;
	// Updating the horizontal position of the current map position
	if (curRoomSector[X] < prevRoomSector[X]){
		prevRoomSector[X] = curRoomSector[X];
		global.mapPosX--;
	} else if (curRoomSector[X] > prevRoomSector[X]){
		prevRoomSector[X] = curRoomSector[X];
		global.mapPosX++;
	}
	// Updating the vertical position of the current map position
	if (curRoomSector[Y] < prevRoomSector[Y]){
		prevRoomSector[Y] = curRoomSector[Y];
		global.mapPosY--;
	} else if (curRoomSector[Y] > prevRoomSector[Y]){
		prevRoomSector[Y] = curRoomSector[Y];
		global.mapPosY++;
	}
}

// Draw the map to the screen
draw_map(278, 2, global.mapPosX - 2, global.mapPosY - 1, miniMapWidth, miniMapHeight, obj_hud.alpha);