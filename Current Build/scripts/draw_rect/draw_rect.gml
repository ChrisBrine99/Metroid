/// @description Draws a rectangle that fills the screen. Can have a gradient and has a variable alpha value.
/// @param alpha
/// @param finalAlpha
/// @param color1
/// @param color2
/// @param gradient
/// @param xPos
/// @param yPos
/// @param width
/// @param height

var alpha, finalAlpha, color1, color2, gradient, xPos, yPos, width, height;
alpha = argument0;
finalAlpha = argument1;
color1 = argument2;
color2 = argument3;
gradient = argument4;
xPos = argument5;
yPos = argument6;
width = argument7;
height = argument8;

// Actually drawing the rectangle
draw_set_alpha(alpha);
if (!gradient){ // Drawing a single colored rectangle
	draw_set_color(color1);
	draw_rectangle(xPos, yPos, xPos + width, yPos + height, false);
}
else{ // Drawing a rectangle with a gradient
	draw_rectangle_color(xPos, yPos, xPos + width, yPos + height, color1, color1, color2, color2, false);	
}
draw_set_alpha(finalAlpha);