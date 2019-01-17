/// @description Makes a grid of arrays based on the width and height given by the user. This 2D array will
/// be used to determine where the player is on the grid as well as where the world is on said map as well.
/// @param mapX
/// @param mapY
/// @param width
/// @param height

var mapX, mapY, width, height;
mapX = argument0;
mapY = argument1;
width = argument2;
height = argument3;

// Set the starting positions of the mapX and mapY
global.mapX = mapX;
global.mapY = mapY;
for (var i = 0; i < height; i++){
	for (var ii = 0; ii < width; ii++){
		global.mapTile[ii, i] = false; // If true, Samus has been on this tile and thus it will be shown on the map.
	}
}