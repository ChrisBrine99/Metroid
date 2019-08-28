/// @description Enabling/Disabling the sprite
// You can write your code in this editor

if (!isDestroyed){
	if (hidden) {draw_tile(tileset_main, tileData, 0, x, y);}
	else {draw_self();}
}