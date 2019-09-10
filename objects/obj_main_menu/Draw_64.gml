/// @description Drawing the Menu
// You can write your code in this editor

draw_set_alpha(alpha);

if (alpha > 0){
	draw_set_font(font_gui_small);

	var length, col, oCol;
	length = array_height_2d(menuOption);
	col = c_gray;
	oCol = c_dkgray;
	for (var i = 0; i < length; i++){
		if (curOption[Y] == i){
			col = c_lime;
			oCol = c_green;
		} else{
			col = c_gray;
			oCol = c_dkgray;
		}
		draw_text_outline(5, 5 + (15 * i), menuOption[i, 0], col, oCol);
	}
}

draw_set_alpha(1);