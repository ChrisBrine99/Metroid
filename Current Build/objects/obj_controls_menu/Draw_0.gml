/// @description Insert description here
// You can write your code in this editor

draw_rect(backAlpha, alpha, rectCol, c_black, true, global.camX, global.camY, global.camWidth, global.camHeight);

draw_set_alpha(alpha);
draw_set_font(font_gui_small);
draw_text_outline(xOffset + 40, yOffset - 20, "IN-GAME CONTROLS", c_white, c_black);
draw_text_outline(xOffset + 205, yOffset - 20, "MENU CONTROLS", c_white, c_black);
// Drawing the keyboard contols 
var xPos, yPos, num, col, keyCol;
xPos = 0;
yPos = 0;
num = 0;
for (var i = 0; i < 10; i++){ // Controls for in-game
	col = c_dkgray;
	keyCol = c_dkgray;
	if (curOption == num){
		col = c_yellow;
		if (selectedOption == curOption)
			col = c_red;
		keyCol = c_white;
		draw_text_outline(xOffset + xPos - 10, yOffset + (textGap * i) + yPos, ">", col, c_black);
	}
	draw_rect(alpha * 0.3, alpha, c_black, c_black, false, xOffset + xPos + 37, yOffset + yPos + (textGap * i) - 1, 47, 11);
	draw_text_outline(xOffset + xPos, yOffset + (textGap * i) + yPos, menuOption[num], col, c_black);
	draw_set_halign(fa_right);
	draw_set_font(font_gui_xSmall);
	draw_text_outline(xOffset + xPos + 84, yOffset + (textGap * i) + yPos + 1, draw_keyboard_key(global.key[num]), keyCol, c_black);
	draw_set_halign(fa_left);
	draw_set_font(font_gui_small);
	num++;
	// Shift the text to the right
	if (i == 4){
		yPos -= (textGap * (i + 1));
		xPos += 100;
	}
}
xPos += 100;
for (var ii = 0; ii < 7; ii++){ // Controls for the menus
	col = c_dkgray;
	keyCol = c_dkgray;
	if (curOption == num){
		col = c_yellow;
		keyCol = c_white;
		draw_text_outline(xOffset + xPos - 10, yOffset + (textGap * ii), ">", col, c_black);
	}
	draw_rect(alpha * 0.3, alpha, c_black, c_black, false, xOffset + xPos + 37, yOffset + (textGap * ii) - 1, 47, 11);
	draw_text_outline(xOffset + xPos, yOffset + (textGap * ii), menuOption[num], col, c_black);
	draw_set_halign(fa_right);
	draw_set_font(font_gui_xSmall);
	draw_text_outline(xOffset + xPos + 84, yOffset + (textGap * ii) + 1, draw_keyboard_key(global.key[num]), keyCol, c_black);
	draw_set_halign(fa_left);
	draw_set_font(font_gui_small);
	num++;
}


if (secAlpha > 0 || selectedOption == curOption){
	if (secAlpha < 1 && selectedOption == curOption)
		secAlpha += 0.2;
	draw_rect(secAlpha, secAlpha, c_red, c_black, true, global.camX, global.camY, global.camWidth, 18);
	draw_set_halign(fa_center);
	draw_text_outline(global.camX + (global.camWidth / 2), global.camY + 4, "Press [" + draw_keyboard_key(prevKey) + "] to leave the keybind as is.", c_red, c_black);
	draw_set_halign(fa_left);
	draw_set_alpha(1);
}

draw_controls(1, global.camX, global.camY, "[" + draw_keyboard_key(global.key[10]) + "/" + draw_keyboard_key(global.key[11]) + "] Move Cursor", "[" + draw_keyboard_key(global.key[14]) + "] Select");

// Drawing an rectangle behind the information text
draw_rect(alpha, 1, c_black, c_black, false, global.camX, global.camY + 140, global.camWidth, 14);
draw_rect(alpha * 0.3, alpha, c_blue,c_black, true, global.camX, global.camY + 141, global.camWidth, 12);
// Drawing information about what each option does
draw_set_font(font_gui_xSmall);
var txt;
txt = "";
switch(curOption){
	case 0: // Right key info
		txt = "Move Samus to the right.";
		break;
	case 1: // Left key info
		txt = "Move Samus to the left.";
		break;
	case 2: // Up key info
		txt = "Makes Samus aim up/stand up/exit morphball.";
		break;
	case 3: // Down key info
		txt = "Makes Samus aim down/crouch/enter morphball.";
		break;
	case 4: // Fire key info
		txt = "Fire the equipped beam/deploys bombs.";
		break;
	case 5: // Jump key info
		txt = "Allows Samus to jump.";
		break;
	case 6: // Equip key info
		txt = "Lets Samus equip her missiles/power bombs.";
		break;
	case 7:	// Beam key info
		txt = "Pressing will switch Samus's current beam.";
		break;
	case 8: // Pause key info
		txt = "Pauses the game.";
		break;
	case 9: // Save key info
		txt = "Press when on save platform to save the game.";
		break;
	case 10: // Moving up in menu info
		txt = "Moves the menu cursor up.";
		break;
	case 11: // Moving down in menu info
		txt = "Moves the menu cursor down.";
		break;
	case 12: // Shift right key info
		txt = "Shifts the menu cursor to the right.";
		break;
	case 13: // Shift left key info
		txt = "Shifts the menu cursor to the left.";
		break;
	case 14: // Select key info
		txt = "Selects the highlighted menu option.";
		break;
	case 15: // Return key info
		txt = "Returns to the previous menu.";
		break;
	case 16: // Delete key info
		txt = "Deletes the highlighted save file.";
		break;
	default:
		txt = "No info";
		break;
}
draw_set_halign(fa_right);
draw_text_outline(global.camX + 290, global.camY + 145, txt, c_white, c_black);
draw_set_halign(fa_left);

// Reset the alpha
draw_set_alpha(1);