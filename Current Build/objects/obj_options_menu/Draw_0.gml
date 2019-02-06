/// @description Insert description here
// You can write your code in this editor

draw_rect(backAlpha, 1, rectCol, c_black, true, global.camX, global.camY, global.camWidth, global.camHeight);

// Call the parent's draw event
event_inherited();

// Drawing whether or not the options are toggled or not
draw_set_font(font_gui_small);
draw_set_halign(fa_right);
var color;
for (var i = 0; i < array_length_1d(optionStr); i++){
	color = c_gray;
	if (curOption == i)
		color = c_white;
	draw_set_color(c_black);
	draw_set_alpha(alpha * 0.3);
	draw_rectangle(global.camX + 140, yOffset - 2 + (textGap * i), global.camX + 270, yOffset + 11 + (textGap * i), false);
	draw_set_alpha(alpha);
	draw_text_outline(global.camX + 268, yOffset + (textGap * i), string(optionStr[i]), color, c_black);
}

// Drawing a rectangle behind the information text
draw_rect(alpha, 1, c_black, c_black, false, global.camX, global.camY + 140, global.camWidth, 14);
draw_rect(alpha * 0.3, alpha, c_blue,c_black, true, global.camX, global.camY + 141, global.camWidth, 12);
// Drawing information about what each option does
draw_set_font(font_gui_xSmall);
var txt;
txt = "";
switch(curOption){
	case 0: // Drawing info for the "Scanlines" option
		txt = "Enable/Disable the scanline overlay effect.";
		break;
	case 1: // Information about V-Sync
		txt = "Enable/Disable V-sync (Prevents tearing).";
		break;
	case 3: // Information about the window scaling option
		txt = "The resolution of the game window.";
		break;
	case 4: // Changing the keybindings
		txt = "Change the keyboard bindings.";
		break;
	case 5: // Resetting the options
		txt = "Reset options to their default settings.";
		break;
	case 6: // Drawing info for the "Back" option
		txt = "Return to the previous menu.";
		break;
}
draw_text_outline(global.camX + 290, global.camY + 145, txt, c_white, c_black);
draw_set_halign(fa_left);
draw_set_alpha(1);