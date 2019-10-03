/// @description Draws the map onto the screen at the given coordinates. The map's size is dictated by the given width and height sizes
/// @param xPos
/// @param yPos
/// @param cellOffsetX
/// @param cellOffsetY
/// @param widthToDraw
/// @param heightToDraw

var xPos, yPos, cellOffsetX, cellOffsetY, widthToDraw, heightToDraw, xLength, yLength;
xPos = argument0;
yPos = argument1;
cellOffsetX = argument2;
cellOffsetY = argument3;
widthToDraw = argument4;
heightToDraw = argument5;

// Make sure the cell offsets don't go below 0 or above the width and height of the map
if (cellOffsetX < 0) {cellOffsetX = 0;}
else if (cellOffsetX > ds_grid_width(global.mapData) - 1 - widthToDraw) {cellOffsetX = ds_grid_width(global.mapData) - 1 - widthToDraw;}
if (cellOffsetY < 0) {cellOffsetY = 0;}
else if (cellOffsetY > ds_grid_height(global.mapData) - 1 - heightToDraw) {cellOffsetX = ds_grid_height(global.mapData) - 1 - widthToDraw;}

// Find out the bottom-right element that will be shown on the grid
xLength = floor(cellOffsetX + widthToDraw);
yLength = floor(cellOffsetY + heightToDraw);

// Make sure that bottom-right element isn't outside of the grid boundaries
if (xLength > ds_grid_width(global.mapData) - 1) {xLength = ds_grid_width(global.mapData) - 1;}
if (yLength > ds_grid_height(global.mapData) - 1) {yLength = ds_grid_height(global.mapData) - 1;}

// Drawing the map to the screen on an 8 by 8 grid
for (var i = cellOffsetX; i < xLength; i++){
	for (var ii = cellOffsetY; ii < yLength; ii++){
		// Drawing the map's tile color
		if (global.mapUncovered[# i, ii]){ // Drawing map tiles only when the player has explored that area of the map
			draw_sprite_ext(spr_generic_rectangle, 0, xPos + (8 * (i - cellOffsetX)), yPos + (8 * (ii - cellOffsetY)), 8, 8, 0, global.mapColor[# i, ii], alpha);
			draw_sprite(spr_map_tiles, global.mapData[# i, ii], xPos + (8 * (i - cellOffsetX)), yPos + (8 * (ii - cellOffsetY)));
		} else{ // Drawing an empty space where the player hasn't uncovered yet	
			draw_sprite_ext(spr_generic_rectangle, 0, xPos + (8 * (i - cellOffsetX)), yPos + (8 * (ii - cellOffsetY)), 8, 8, 0, c_black, alpha);
			draw_sprite(spr_map_tiles, 0, xPos + (8 * (i - cellOffsetX)), yPos + (8 * (ii - cellOffsetY)));
		}
		// Drawing the player's position on the map screen
		if (i == global.mapPosX && ii == global.mapPosY){
			if (global.isVisible){draw_sprite_ext(spr_generic_rectangle, 0, xPos + (8 * (i - cellOffsetX)) + 2, yPos + (8 * (ii - cellOffsetY)) + 2, 4, 4, 0, global.pRectCol, alpha);}
		}
	}
}