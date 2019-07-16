/// @description Draws text with a nice outline around it.
/// @param posX
/// @param posY
/// @param text
/// @param textCol
/// @param outlineCol

var posX, posY, text, textCol, outlineCol;
posX = argument0;			// The X position of the text
posY = argument1;			// The y position of the text
text = argument2;			// The text itself
textCol = argument3;		// The color of the text
outlineCol = argument4;		// The color of the text's outline

// Drawing the outline
draw_set_color(outlineCol);
draw_text(posX - 1, posY - 1, text);
draw_text(posX - 1, posY, text);
draw_text(posX - 1, posY + 1, text);
draw_text(posX, posY - 1, text);
draw_text(posX, posY + 1, text);
draw_text(posX + 1, posY - 1, text);
draw_text(posX + 1, posY, text);
draw_text(posX + 1, posY + 1, text);
// Drawing the text itself
draw_set_color(textCol);
draw_text(posX, posY, text);