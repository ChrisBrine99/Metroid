/// @description Draws keyboard controls at the bottom right and bottom left of any menu that calls this script.
/// @param alpha
/// @param xPos
/// @param yPos
/// @param rightStr
/// @param leftStr

var alpha, xPos, yPos, rightStr, leftStr;
alpha = argument0;
xPos = argument1;
yPos = argument2;
rightStr = argument3;
leftStr = argument4;

// Set the alpha
draw_set_alpha(alpha);

// Set the text to right alignment
draw_set_halign(fa_right);
// Draw control options on the right hand side of the screen
draw_set_font(font_gui_xSmall);
draw_text_outline(xPos + 318, yPos + 174 - string_height(rightStr), rightStr, c_white, c_black);
// Return the text to the correct alignment
draw_set_halign(fa_left);
// Drawing more controls at the bottom left hand of the screen
draw_text_outline(xPos + 2, yPos + 174 - string_height(leftStr), leftStr, c_white, c_black);	

// Return the alpha to one
draw_set_alpha(1);