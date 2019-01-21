/// @description Drawing the GUI
// You can write your code in this editor

var normAlpha;
normAlpha = 1;
if (instance_exists(obj_fade))
	normAlpha = 1 - obj_fade.setAlpha;
draw_set_alpha(normAlpha);

// Item Collection Screen /////////////////////////////////////////////////////////////////////////////////

if (global.itemCollected){
	// Drawing the background for the item collection screen
	draw_rect(0.3, 1, c_black, c_white, false, global.camX, global.camY, global.camWidth, global.camHeight);
	// Center the horizontal alignment
	draw_set_halign(fa_center);
	// Drawing the item name
	draw_set_font(font_gui_large);
	draw_text_outline(global.camX + (global.camWidth / 2), global.camY + 60, global.itemName, c_white, c_black);
	// Drawing the item description
	draw_set_font(font_gui_small);
	draw_text_outline(global.camX + (global.camWidth / 2), global.camY + 95, global.itemDescription, c_white, c_black);
	
	if (!audio_is_playing(global.itemTheme)){
		draw_text_outline(global.camX + (global.camWidth / 2), global.camY + 160, "Press [Shoot] to continue.", c_white, c_black);
	}
	
	// Reset the horizontal alignment
	draw_set_halign(fa_left);
	return;
}

// Game Over Effect ///////////////////////////////////////////////////////////////////////////////////////

if (global.energy == 0 && global.eTanks == 0){
	if (rectAlpha < 0.5){rectAlpha += 0.05;}
	draw_rect(rectAlpha, textAlpha, c_maroon, c_white, false, global.camX, global.camY, global.camWidth, global.camHeight);
}

// If the pause menu is open //////////////////////////////////////////////////////////////////////////////

if (instance_exists(obj_pause_menu)){
	return;	
}

// Everything below here is for the HUD ///////////////////////////////////////////////////////////////////

// Drawing the current energy amount
draw_set_font(font_gui_large);
var healthCol;
// Setting the color of the health
if (global.eTanks == 0 && global.energy < 30){
	healthCol = make_color_rgb(255 - (99 - global.energy), 255 - ((global.maxEnergy * 2.55) - (global.energy * 2.55)), 255 - ((global.maxEnergy * 2.55) - (global.energy * 2.55)));
}
else{
	healthCol = c_white;
}
// Drawing the amount to the screen
if (global.energy >= 10){
	draw_text_outline(global.camX + 2, global.camY + 3, string(global.energy), healthCol, c_black);
}
else{
	draw_text_outline(global.camX + 2, global.camY + 3, "0" + string(global.energy), healthCol, c_black);
}
var xOffset, yOffset, index, color;
xOffset = global.camX + 23;
yOffset = 0;
index = 0;
color = c_white;
// Drawing the energy tanks 
for (var i = 0; i < global.eTanksMax; i++){
	if (i >= 6){
		xOffset = global.camX + 30 + ((i - 6) * 8);
		yOffset = 10;
	}
	else{
		xOffset = global.camX + 30 + (i * 8);
		if (global.eTanksMax <= 6) yOffset = 6;
		else yOffset = 2;
	}
	if (i < global.eTanks) // Drawing a full energy tank
		draw_sprite(spr_energy_tank_hud, 0, xOffset, global.camY + 1 + yOffset);
	else
		draw_sprite(spr_energy_tank_hud, 1, xOffset, global.camY + 1 + yOffset);
}
if (global.eTanksMax > 6){
	xOffset = global.camX + 70;	
}

draw_set_font(font_gui_small);
var str;
if (global.maxEquipmentIndex > 0){
	if (global.curEquipmentIndex == 1){ 
		color = make_color_rgb(184, 248, 24);
		index = 1;
	}
	// Drawing the Regular Missiles stats
	if (global.missiles < 10) str = "00" + string(global.missiles);
	else if (global.missiles < 100) str = "0" + string(global.missiles);
	else str = string(global.missiles);
	draw_sprite(spr_missile_hud, index, xOffset + 10, global.camY + 6);
	draw_text_outline(xOffset + 22, global.camY + 6, str, color, c_black);
	xOffset += 32;
}
if (global.maxEquipmentIndex > 1){
	// Reset the index and color variables
	index = 0;
	color = c_white;
	if (global.curEquipmentIndex == 2){
		color = make_color_rgb(184, 248, 24);
		index = 1;
	}
	// Drawing the Super Missiles stats
	if (global.sMissiles < 10) str = "0" + string(global.sMissiles);
	else str = string(global.sMissiles);
	draw_sprite(spr_sMissile_hud, index, xOffset + 13, global.camY + 5);
	draw_text_outline(xOffset + 29, global.camY + 6, str, color, c_black);
	xOffset += 40;
}
if (global.maxEquipmentIndex > 2){
	// Reset the index and color variables
	index = 0;
	color = c_white;
	if (global.curEquipmentIndex == 3){
		color = make_color_rgb(184, 248, 24);
		index = 1;
	}
	// Drawing the Power Bomb stats
	if (global.pBombs < 10) str = "0" + string(global.pBombs);
	else str = string(global.pBombs);
	draw_sprite(spr_pBomb_hud, index, xOffset + 5, global.camY + 6);
	draw_text_outline(xOffset + 17, global.camY + 6, str, color, c_black);
}

// Displaying the help message/info message
if (displayTimer > 0){
	displayTimer--;
	draw_set_halign(fa_center);
	if (displayTimer < 10) draw_set_alpha(displayTimer / 10);
	draw_text_outline(global.camX + (global.camWidth / 2), global.camY + 150, displayTxt, c_white, c_black);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
}

// Drawing the name of the beam to the screen
if (textAlpha > 0){
	var beamName = "Powerbeam";
	draw_set_alpha(textAlpha * normAlpha);
	// Finding the name of the current equipped beam
	switch(global.curBeamIndex){
		case 0: // The Powerbeam
			beamName = "Power Beam";
			break;
		case 1: // The Icebeam
			beamName = "Ice Beam";
			break;
		case 2: // The Wavebeam
			beamName = "Wave Beam";
			break;
		case 3: // The Spazerbeam
			beamName = "Spazer Beam";
			break;
		case 4: // The Plasmabeam
			beamName = "Plasma Beam";
			break;
	}
	draw_text_outline(global.camX + 2, global.camY + global.camHeight - 26, beamName, c_white, c_black);
	draw_set_alpha(normAlpha);
}
// Drawing the beams to the screen
var spr, imgNum;
if (showBeamsTimer <= 5){
	if (yPos >= 20){
		if (xPos > 2) xPos -= 2;
		else{
			if (textAlpha > 0) textAlpha -= 0.1;
			xPos = 1;
		}
	}
	// Finding the current beam
	imgNum = 0;
	switch(global.curBeamIndex){
		case 0: // Powerbeam
			spr = spr_powerbeam_hud;
			break;
		case 1: // Icebeam
			spr = spr_icebeam_hud;
			break;
		case 2: // Wavebeam
			spr = spr_wavebeam_hud;
			break;
		case 3: // Spazerbeam
			spr = spr_spazerbeam_hud;
			break;
		case 4: // Plasmabeam
			spr = spr_plasmabeam_hud;
			break;
	}
	draw_sprite(spr, imgNum, global.camX + xPos, global.camY + global.camHeight - 16);
}
if (showBeamsTimer >= 5){
	if (textAlpha < 1) textAlpha += 0.1;
	if (yPos > 0) yPos -= 4;
	else yPos = 0;
}
else{
	yPos += 4;
	if (yPos >= 20) yPos = 20; 
}
// Only draw these when the player is cycling through their beams
if (showBeamsTimer > 0){
	for (var i = 0; i <= global.maxBeamIndex; i++){
		imgNum = 1;
		switch(i){
			case 0: // Powerbeam
				spr = spr_powerbeam_hud;
				break;
			case 1: // Icebeam
				spr = spr_icebeam_hud;
				break;
			case 2: // Wavebeam
				spr = spr_wavebeam_hud;
				break;
			case 3: // Spazerbeam
				spr = spr_spazerbeam_hud;
				break;
			case 4: // Plasmabeam
				spr = spr_plasmabeam_hud;
				break;
		}
		if (global.curBeamIndex == i){
			xPos = 1 + (i * 16);
			if (showBeamsTimer >= 5) {
				imgNum = 0;
			}
			else{
				if (global.maxBeamIndex > i) i++;
				else return;
			}
		}
		draw_sprite(spr, imgNum, global.camX + 1 + (i * 16), global.camY + global.camHeight - 16 + yPos);
	}
}

// Drawing the Debug Menu
if (global.debug){
	// Drawing Samus's collision mask
	draw_sprite_ext(obj_samus.mask_index, 0, obj_samus.x, obj_samus.y, obj_samus.image_xscale, obj_samus.image_yscale, 0, c_white, 0.3);
	// Drawing the background for the debug menu
	draw_set_alpha(normAlpha * 0.3);
	draw_set_color(c_dkgray);
	draw_rectangle(global.camX + 216, global.camY, global.camX + global.camWidth, global.camY + 110, false);
	var hr, mn, sc;
	hr = string(global.hours);
	mn = string(global.minutes);
	sc = string(global.seconds);
	if (global.hours < 10) hr = "0" + hr;
	if (global.minutes < 10) mn = "0" + mn;
	if (global.seconds < 10) sc = "0" + sc;
	draw_set_alpha(normAlpha);
	draw_text_outline(global.camX + 220, global.camY + 2, "-- Debug Menu --\nTime: " + hr + ":" + mn + ":" + sc + "\nFPS: " + string(fps) + "\nInstances: " + string(instance_number(all)) + "\nxPos: " + string(obj_samus.x) + "\nyPos: " + string(obj_samus.y) + "\nxVel: " + string(obj_samus.hspd) + "\nyVel: " + string(obj_samus.vspd), c_white, c_black);
}

// Make sure the alpha is set back to 1
draw_set_alpha(1);