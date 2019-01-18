/// @description Insert description here
// You can write your code in this editor

// Call the parent's draw event
event_inherited();

draw_set_alpha(alpha);
draw_set_halign(fa_right);
var txt;
txt = "";
switch(curOption){
	case 0: // Drawing info for the "Scanlines" option
		txt = "Enables/Disables the scanline overlay effect.";
		break;
	case 1:
		break;
	case 6: // Drawing info for the "Back" option
		txt = "Return to the previous menu.";
		break;
}
draw_text_outline(global.camX + 290, global.camY + 140, txt, c_white, c_black);
draw_set_halign(fa_left);
draw_set_alpha(1);