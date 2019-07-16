/// @description Draws a rectangle with a nice outline around it.
/// @param xPos
/// @param yPos
/// @param width
/// @param height
/// @param rectCol
/// @param outlineCol

var xPos, yPos, width, height, rectCol, outlineCol;
xPos = argument0;			// The x position of the rectangle
yPos = argument1;			// The y position of the rectangle
width = argument2;			// The width of the rectangle
height = argument3;			// The height of the rectangle
rectCol = argument4;		// The color of the inner rectangle
outlineCol = argument5;		// The color of the rectangle's outline

draw_set_color(outlineCol);
draw_rectangle(xPos - 1, yPos - 1, xPos + width + 1, yPos + height + 1, false);
draw_set_color(rectCol);
draw_rectangle(xPos, yPos, xPos + width, yPos + height, false);