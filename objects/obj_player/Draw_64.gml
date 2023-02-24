draw_set_font(font_gui_small);
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(camera_get_width() - 5, 5, game_state_get_name(GAME_CURRENT_STATE));
draw_set_halign(fa_left);
draw_text(5, 5, 
	"Energy " + string(hitpoints) + "/" + string(maxHitpoints) + "\n" +
	"Aeion " + string(curAeion) + "/" + string(maxAeion) + "\n\n" +
	"Missiles " + string(numMissiles) + "/" + string(maxMissiles) + "\n" +
	"Power Bombs " + string(numPowerBombs) + "/" + string(maxPowerBombs)
);