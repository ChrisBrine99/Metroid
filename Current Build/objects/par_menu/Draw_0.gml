/// @description Drawing a basic menu
// You can write your code in this editor

draw_set_font(font_gui_small);
var color;
for (var i = 0; i < menuSize; i++){
	color = c_gray;
	if (curOption == i){
		color = c_white;
	}
	draw_text_outline(xOffset + global.camWidth / 2, yOffset + textPos + (textGap * i), menuOption[i], color, c_black);
}