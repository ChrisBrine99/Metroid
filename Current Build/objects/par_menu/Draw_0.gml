/// @description Drawing a basic menu
// You can write your code in this editor

// Draw a blue gradient for the title screen
if (drawBack)
	draw_rect(backAlpha, 1, rectCol, c_black, true, global.camX, global.camY, global.camWidth, global.camHeight);

draw_set_alpha(alpha);
draw_set_font(font_gui_small);
var color;
for (var i = 0; i < menuSize; i++){
	color = c_gray;
	if (curOption == i){
		color = c_yellow;
		draw_text_outline(xOffset - 10 + textPos, yOffset + (textGap * i), ">", color, c_black);
	}
	draw_text_outline(xOffset + textPos, yOffset + (textGap * i), menuOption[i], color, c_black);
}

if (drawHelp)
	draw_controls(1, global.camX, global.camY, "[" + draw_keyboard_key(global.key[10]) + "/" + draw_keyboard_key(global.key[11]) + "] Move Cursor", "[" + draw_keyboard_key(global.key[14]) + "] Select");