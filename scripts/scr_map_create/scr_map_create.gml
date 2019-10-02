/// @description Creates the neccessary variables for the map to work properly.
/// @param mapWidth
/// @param mapHeight
/// @param miniMapWidth
/// @param miniMapHeight

var mapWidth, mapHeight, mapSurf;
mapWidth = argument0;
mapHeight = argument1;
mapSurf = surface_create(mapWidth, mapHeight);

// Create an Empty Map Template which will be filled in later
global.mapData = ds_grid_create(mapWidth, mapHeight);
global.mapUncovered = ds_grid_create(mapWidth, mapHeight);
global.mapColor = ds_grid_create(mapWidth, mapHeight);
for (var i = 0; i < mapWidth; i++){
	for (var ii = 0; ii < mapHeight; ii++){
		ds_grid_add(global.mapData, i, ii, 0);
		ds_grid_add(global.mapUncovered, i, ii, false);
		ds_grid_add(global.mapColor, i, ii, c_black);
	}
}

// Draw the map sprite to the surface
surface_set_target(mapSurf);

surface_reset_target();

// Build the map from hard-coded values for testing //////////////////////////////////////////

// Data for rm_test0
global.mapData[# 11, 3] = 20;
global.mapColor[# 11, 3] = c_orange;
global.mapData[# 10, 3] = 45;
global.mapColor[# 10, 3] = c_orange;
global.mapData[# 9, 3] = 42;
global.mapColor[# 9, 3] = c_orange;
global.mapData[# 9, 2] = 56;
global.mapColor[# 9, 2] = c_orange;
global.mapData[# 10, 2] = 64;
global.mapColor[# 10, 2] = c_orange;

// Data for rm_test1
global.mapData[# 8, 3] = 19;
global.mapColor[# 8, 3] = c_blue;
global.mapData[# 7, 3] = 12;
global.mapColor[# 7, 3] = c_blue;
global.mapData[# 6, 3] = 9;
global.mapColor[# 6, 3] = c_blue;

// Data for rm_test2
global.mapData[# 5, 3] = 3;
global.mapColor[# 5, 3] = c_blue;

//////////////////////////////////////////////////////////////////////////////////////////////

// Destroy the temporary surface
surface_free(mapSurf);

// The size of the mini-map on the in-game HUD
miniMapWidth = argument2;
miniMapHeight = argument3;

// The position of the player on the map
global.mapPosX = 11;
global.mapPosY = 3;
global.mapUncovered[# global.mapPosX, global.mapPosY] = true;

curRoomSector = [0, 0];
if (instance_exists(obj_player)){
	curRoomSector = [floor(obj_player.x / global.camWidth), floor(obj_player.y / global.camHeight)];
}
prevRoomSector = curRoomSector;