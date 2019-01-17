/// @description Drawing the Menu
// You can write your code in this editor

// Draw a blue gradient for the main menu screen
draw_rect(0.15, 1, c_blue, c_black, true, 0, 0, global.camWidth, global.camHeight);

// Drawing rectangles behind the 3 file options
draw_set_color(c_black);
draw_set_alpha(alpha * 0.3);
for (var a = 0; a < 3; a++){
	draw_rectangle(58, 28 + (a * 30), 262, 54 + (a * 30), false);
}
draw_set_alpha(alpha);

for (var b = 0; b < 3; b++){
	draw_set_font(font_gui_large);
	// Drawing the energy data
	if (enData[b] >= 10) draw_text_outline(96, 34 + (b * 30), string(enData[b]), c_white, c_black);
	else draw_text_outline(96, 34 + (b * 30), "0" + string(enData[b]), c_white, c_black);
	// Drawing the energy tanks
	var xPos, yPos;
	xPos = 0;
	yPos = 0;
	for (var bb = 0; bb < eTankMaxData[b]; bb++){
		if (bb >= 6){
			xPos = 126 + ((bb - 6) * 8);
			yPos = 10;
		}
		else{
			xPos = 126 + (bb * 8);
			if (eTankMaxData[b] <= 6) yPos = 6;
			else yPos = 2;
		}
		if (bb < eTankData[b]) // Drawing a full energy tank
			draw_sprite(spr_energy_tank_hud, 0, xPos, 31 + (30 * b) + yPos);
		else
			draw_sprite(spr_energy_tank_hud, 1, xPos, 31 + (30 * b) + yPos);
	}
	// Drawing the time data
	draw_set_font(font_gui_small);
	
	// Drawing the time data
	//draw_text_outline(190, 37 + (b * 30), "Time: 00:00", c_white, c_black);
	var str = "";
	if (minuteData[b] < 10) str = "0";
	if (hourData[b] >= 10){
		draw_text_outline(190, 37 + (b * 30), "Time: " + string(hourData[b]) + ":" + str + string(minuteData[b]), c_white, c_black);		
	}
	else{
		draw_text_outline(190, 37 + (b * 30), "Time: 0" + string(hourData[b]) + ":" + str + string(minuteData[b]), c_white, c_black);			
	}
}


draw_set_font(font_gui_small);
// Modifying the Menu drawing stuff a little bit
var color, xOffset;
xOffset = 0;
for (var i = 0; i < menuSize; i++){ // This code is disgusting, but it works so... yeah...
	color = c_gray;
	draw_set_font(font_gui_xSmall);
	if (curOption == i) color = c_yellow;
	if (i >= 3){
		xOffset = 200;
		draw_set_font(font_gui_small);
		draw_set_halign(fa_right);
	}
	if (i < menuSize - 1){
		draw_text_outline(60 + xOffset, textPos + (textGap * i), menuOption[i], color, c_black);
		if (curOption == i){
			draw_set_font(font_gui_small);
			if (i < menuSize - 2) draw_text_outline(50 + xOffset, textPos + (textGap * i), ">", color, c_black);
			else draw_text_outline(xOffset, textPos + (textGap * i), ">", color, c_black);
		}
	}
	else {
		draw_text_outline(60 + xOffset, textPos + (textGap * (i - 1)) + 16, menuOption[i], color, c_black);
		if (curOption == i){
			draw_set_font(font_gui_small);
			draw_text_outline(xOffset, textPos + (textGap * (i - 1)) + 16, ">", color, c_black);
		}
	}
}
// Set the text to right alignment
draw_set_halign(fa_right);

// Draw control options on the right hand side of the screen
draw_set_font(font_gui_xSmall);
draw_text_outline(318, 164, "[Up/Down] Move Cursor", c_white, c_black);

// Return the text to the correct alignment
draw_set_halign(fa_left);

// Drawing more controls at the bottom left hand of the screen
draw_text_outline(2, 154, "[Z] Select\n[D] Delete File", c_white, c_black);

// Reset the alpha value
draw_set_alpha(1);