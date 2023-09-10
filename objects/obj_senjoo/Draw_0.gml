entity_draw();

flipTimer += DELTA_TIME;
if (flipTimer >= spriteSpeed){
	flipTimer	 -= spriteSpeed;
	image_xscale *= -1;
}