/// @description Draws the map onto the screen based on the given cell offsets, width and height provided in the argument fields.
/// @param xPos
/// @param yPos
/// @param cellOffsetX
/// @param cellOffsetY
/// @param widthToDraw
/// @param heightToDraw
/// @param alpha

var xPos, yPos, cellOffsetX, cellOffsetY, widthToDraw, heightToDraw, alpha, xLength, yLength;
xPos = argument0;
yPos = argument1;
cellOffsetX = argument2;
cellOffsetY = argument3;
widthToDraw = argument4;
heightToDraw = argument5;
alpha = argument6;
xLength = cellOffsetX + widthToDraw;
yLength = cellOffsetY + heightToDraw;

// Drawing the map to the screen on an 8 by 8 grid
draw_set_alpha(alpha);
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
	}
}
draw_set_alpha(1);