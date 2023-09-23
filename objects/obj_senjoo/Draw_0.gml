entity_draw();

// 
if (GAME_CURRENT_STATE == GSTATE_NORMAL){
	flipTimer += DELTA_TIME * spriteSpeed;
	if (flipTimer > 1.0){
		flipTimer	 -=  1.0;
		image_xscale *= -1;
	}
}