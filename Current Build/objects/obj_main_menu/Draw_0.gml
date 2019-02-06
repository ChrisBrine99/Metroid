/// @description Drawing the Menu
// You can write your code in this editor

// Draw a blue gradient for the main menu screen
draw_rect(0.15, 1, c_blue, c_black, true, 0, 0, global.camWidth, global.camHeight);

// Drawing rectangles behind the 3 file options
draw_set_alpha(alpha * 0.3);
for (var a = 0; a < 3; a++){
	if (curOption = a) draw_set_color(c_dkgray);
	else draw_set_color(c_black);
	draw_rectangle(58, 28 + (a * 30), 262, 54 + (a * 30), false);
}
draw_set_alpha(alpha);

for (var b = 0; b < 3; b++){
	var str, col;
	str = "";
	col = c_ltgray;
	if (curOption = b) 
		col = c_white;
	draw_set_font(font_gui_large);
	// Drawing the energy data
	if (enData[b] >= 10) draw_text_outline(96, 34 + (b * 30), string(enData[b]), col, c_black);
	else draw_text_outline(96, 34 + (b * 30), "0" + string(enData[b]), col, c_black);
	// Drawing the energy tanks
	var xPos, yPos;
	xPos = 0;
	yPos = 0;
	for (var bb = 0; bb < eTankMaxData[b]; bb++){
		if (bb >= 6){
			xPos = 125 + ((bb - 6) * 8);
			yPos = 10;
		}
		else{
			xPos = 125 + (bb * 8);
			if (eTankMaxData[b] <= 6) yPos = 6;
			else yPos = 2;
		}
		if (bb < eTankData[b]) // Drawing a full energy tank
			draw_sprite(spr_energy_tank_hud, 0, xPos, 31 + (30 * b) + yPos);
		else
			draw_sprite(spr_energy_tank_hud, 1, xPos, 31 + (30 * b) + yPos);
	}
	// Drawing the time data
	draw_set_font(font_gui_xSmall);
	
	// Drawing the time data
	//draw_text_outline(190, 37 + (b * 30), "Time: 00:00", c_white, c_black);
	if (minuteData[b] < 10) str = "0";
	if (hourData[b] >= 10){
		draw_text_outline(213, 47 + (b * 30), "Time " + string(hourData[b]) + ":" + str + string(minuteData[b]), col, c_black);		
	}
	else{
		draw_text_outline(213, 47 + (b * 30), "Time 0" + string(hourData[b]) + ":" + str + string(minuteData[b]), col, c_black);			
	}
	// Drawing the file's beam data to the screen
	for (var ii = 0; ii < 5; ii++){
		if (ii < beamData[b]) draw_sprite(spr_beams_menu, ii, 176 + (7 * ii), 47 + (b * 30));
		else draw_sprite(spr_beams_menu, 5, 176 + (7 * ii), 47 + (b * 30));
	}
	// Drawing the file's missile data to the screen
	if (equipData[b] > 0){
		draw_sprite(spr_missile_hud, 0, 180, 34 + (b * 30));
		if (missData[b] < 10) draw_text_outline(192, 36 + (b * 30), "00" + string(missData[b]), col, c_black);
		else if (missData[b] < 100) draw_text_outline(192, 36 + (b * 30), "0" + string(missData[b]), col, c_black);
		else draw_text_outline(192, 36 + (b * 30), string(missData[b]), col, c_black);
	}
	// Drawing the file's super missile data to the screen
	if (equipData[b] > 1){
		draw_sprite(spr_sMissile_hud, 0, 208, 33 + (b * 30));
		if (sMissData[b] < 10) draw_text_outline(224, 36 + (b * 30), "0" + string(sMissData[b]), col, c_black);
		else draw_text_outline(224, 36 + (b * 30), string(sMissData[b]), col, c_black);
	}
	// Drawing the file's power bomb data to the screen
	if (equipData[b] > 2){
		draw_sprite(spr_pBomb_hud, 0, 235, 35 + (b * 30));
		if (pBombData[b] < 10) draw_text_outline(247, 36 + (b * 30), "0" + string(pBombData[b]), col, c_black);
		else draw_text_outline(247, 36 + (b * 30), string(pBombData[b]), col, c_black);
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
		draw_text_outline(60 + xOffset, yOffset + (textGap * i), menuOption[i], color, c_black);
		if (curOption == i){
			draw_set_font(font_gui_small);
			if (i < menuSize - 2) draw_text_outline(50 + xOffset, yOffset + (textGap * i), ">", color, c_black);
			else draw_text_outline(xOffset, yOffset + (textGap * i), ">", color, c_black);
		}
	}
	else {
		draw_text_outline(60 + xOffset, yOffset + (textGap * (i - 1)) + 16, menuOption[i], color, c_black);
		if (curOption == i){
			draw_set_font(font_gui_small);
			draw_text_outline(xOffset, yOffset + (textGap * (i - 1)) + 16, ">", color, c_black);
		}
	}
}

var controlStr;
controlStr = "[" + draw_keyboard_key(global.key[14]) + "] Select";
if (curOption < 3) // Let the user know they can delete files by pushing D
	controlStr = "[" + draw_keyboard_key(global.key[14]) + "] Select\n[" + draw_keyboard_key(global.key[16]) + "] Delete File";
// Draw the controls to the screen
if (nextMenu == obj_title_menu) 
	draw_controls(alpha, global.camX, global.camY, "[" + draw_keyboard_key(global.key[10]) + "/" + draw_keyboard_key(global.key[11]) + "] Move Cursor", controlStr);
else
	draw_controls(1, global.camX, global.camY, "[" + draw_keyboard_key(global.key[10]) + "/" + draw_keyboard_key(global.key[11]) + "] Move Cursor", controlStr);

// Reset the alpha value
draw_set_alpha(1);