/// @description Draw the Prompt
// You can write your code in this editor

// Setting the font
draw_set_font(font);

if (alpha > 0){
	draw_set_halign(txtAlignment);
	draw_set_alpha(alpha);
	draw_text_outline(xPos, yPos, displayTxt, displayTxtCol, displayTxtOCol);
	draw_set_halign(fa_left);	
	draw_set_alpha(1);
}