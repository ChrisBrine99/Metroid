/// @description Draws a rectangle with a nice outline around it. The inner rectangle can be translucent
/// or opaque. On top of this, the inner rectangle can have a dual-color gradient.
/// @param xPos
/// @param yPos
/// @param width
/// @param height
/// @param rectCol
/// @param rectCol2
/// @param outlineCol
/// @param alpha
/// @param outlineAlpha

var xPos, yPos, width, height, rectCol, rectCol2, outlineCol, alpha, outlineAlpha;
xPos = argument0;			// The x position of the rectangle
yPos = argument1;			// The y position of the rectangle
width = argument2;			// The width of the rectangle
height = argument3;			// The height of the rectangle
rectCol = argument4;		// The color of the inner rectangle
rectCol2 = argument5;		// The second color for the rectangle (Produces a vertical gradient)
outlineCol = argument6;		// The color of the rectangle's outline
alpha = argument7;			// The alpha level of the inner rectangle
outlineAlpha = argument8;	// The alpha level of the outer rectangle

// Prevent the alpha level from going too high or too low
if (alpha > 1) {alpha = 1;}
else if (alpha < 0) {alpha = 0;}
// Prevent the outlineAlpha level form going too high or too low
if (outlineAlpha > 1) {outlineAlpha = 1;}
else if (outlineAlpha < 0) {outlineAlpha = 0;}

// Drawing an outlined rectangle with an opaque center
if (alpha == 1){
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos - 1, yPos - 1, width + 2, height + 2, 0, outlineCol, outlineCol, outlineCol, outlineCol, 1);
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos, yPos, width, height, 0, rectCol, rectCol, rectCol2, rectCol2, 1);
} else{ // Drawing an outline rectangle with a translucent center
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos, yPos, width, height, 0, rectCol, rectCol, rectCol2, rectCol2, alpha);	
	// Drawing the border
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos - 1, yPos - 1, 1, height + 2, 0, outlineCol, outlineCol, outlineCol, outlineCol, outlineAlpha);		// Left Outline Section
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos + width, yPos - 1, 1, height + 2, 0, outlineCol, outlineCol, outlineCol, outlineCol, outlineAlpha);	// Right Outline Section
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos, yPos - 1, width + 1, 1, 0, outlineCol, outlineCol, outlineCol, outlineCol, outlineAlpha);			// Upper Outline Section
	draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos, yPos + height, width + 1, 1, 0, outlineCol, outlineCol, outlineCol, outlineCol, outlineAlpha);		// Bottom Outline Section
}