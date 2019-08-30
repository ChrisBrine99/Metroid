/// @description Enabling/Disabling the sprite
// You can write your code in this editor

// Only draw the sprite if it is visible on the camera
if (x >= global.camX - 16 && y >= global.camY - 16 && x <= global.camX + global.camWidth && y <= global.camY + global.camHeight){
	if (!isDestroyed){
		if (hidden) {draw_tile(tileset_main, tileData, 0, x, y);}
		else {draw_self();}
	}
}