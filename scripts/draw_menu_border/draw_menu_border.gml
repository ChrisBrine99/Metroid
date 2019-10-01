/// @description Draws a border at the top and bottom of the screen with the desired color and outline color
/// that is provided in their respective arguments. On top of that, this background can also draw an inner 
/// rectangle for the main background of any menu that needs one.
/// @param topBorderSize
/// @param botBorderSize
/// @param rectCol
/// @param col
/// @param oCol
/// @param rectAlpha
/// @param alpha
/// @param oAlpha
/// @param gradient
/// @param gCol

var topBorderSize, botBorderSize, rectCol, col, oCol, rectAlpha, alpha, oAlpha, gradient, gCol;
topBorderSize = argument0;		// The size in pixels of the top portion of the border
botBorderSize = argument1;		// The size in pixels of the bottom portion of the border
rectCol = argument2;			// The color of the rectangle in-between the borders
col = argument3;				// The color of the border itself
oCol = argument4;				// The color of the border's outline
rectAlpha = argument5;			// The alpha level of the inner rectangle
alpha = argument6;				// The alpha level for the border and its outline
oAlpha = argument7;				// The alpha level for the border's outline
gradient = argument8;			// If true, a gradient will be present in the border
gCol = argument9;				// The color of the gradient for the border

// Drawing the main rectangle for the border
if (alpha > 0){
	if (gradient){ // Drawing with a gradient if it is enabled
		draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, 0, 0, global.camWidth, topBorderSize, 0, gCol, gCol, col, col, alpha);
		draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, 0, global.camHeight, global.camWidth, -topBorderSize, 0, gCol, gCol, col, col, alpha);
	} else{ // Drawing the border with a single color otherwise
		draw_sprite_ext(spr_generic_rectangle, 0, 0, 0, global.camWidth, topBorderSize, 0, col, alpha);
		draw_sprite_ext(spr_generic_rectangle, 0, 0, global.camHeight, global.camWidth, -topBorderSize, 0, col, alpha);
	}
}

// Drawing the border's outline
if (oAlpha > 0){
	draw_sprite_ext(spr_generic_rectangle, 0, 0, topBorderSize, global.camWidth, 1, 0, oCol, oAlpha);
	draw_sprite_ext(spr_generic_rectangle, 0, 0, global.camHeight - topBorderSize, global.camWidth, -1, 0, oCol, oAlpha);
}

// Drawing the border's inner rectangle
if (rectAlpha > 0){
	draw_sprite_ext(spr_generic_rectangle, 0, 0, topBorderSize + 1, global.camWidth, global.camHeight - (topBorderSize + botBorderSize + 2), 0, oCol, rectAlpha);
}