/// @description Displaying the Prompt
// You can write your code in this editor

#region Some local variables for holding values relating to the text being displayed

var txtHalfWidth, txtHalfHeight;
draw_set_font(font_gui_xSmall);
txtHalfWidth = floor(string_width(displayTxt) / 2);
txtHalfHeight = floor(string_height(displayTxt) / 2);

#endregion

#region Drawing to the screen

if (alpha > 0){
	// Drawing the prompt's background
	var rectAlpha, rectPosY, rectHeight;
	rectAlpha = alpha * 0.3;
	rectPosY = 112 - txtHalfHeight - 10;
	rectHeight = (txtHalfHeight + 10) * 2;
	draw_sprite_ext(spr_generic_rectangle, 0, 0, 0, global.camWidth, global.camHeight, 0, c_black, rectAlpha);
	draw_sprite_ext(spr_generic_rectangle, 0, 0, rectPosY, global.camWidth, rectHeight, 0, c_dkgray, rectAlpha);
	draw_sprite_ext(spr_generic_rectangle, 0, 0, rectPosY + 6, global.camWidth, rectHeight - 12, 0, c_dkgray, rectAlpha);
	
	// Checking if the text needs to be scrolled or not
	if (displayTxt != curDisplayedStr){
		if (scrollingText){
			curDisplayedStr += string_char_at(displayTxt, nextChar);
			nextChar++;	
		} else{
			curDisplayedStr	= displayTxt;
		}
	}
	
	// Drawing the item's description
	draw_set_alpha(alpha);
	draw_set_halign(txtAlignment);
	if (txtAlignment == fa_center) {txtHalfWidth = 0;}
	draw_text_outline((global.camWidth / 2) - txtHalfWidth, 112 - txtHalfHeight, curDisplayedStr, txtCol, txtOCol);
	draw_set_halign(fa_center);
	
	// Displaying the user prompt to close the menu
	if (curDisplayedStr == displayTxt){
		draw_text_outline(global.camWidth / 2, 112 + txtHalfHeight + 20, "Press [Z] To Continue", c_white, c_gray);
	}
	
	// Drawing the item's name
	draw_set_font(font_gui_large);
	draw_text_outline(global.camWidth / 2, 60, itemName, nameCol, nameOCol);
	draw_set_halign(fa_left);
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

#endregion