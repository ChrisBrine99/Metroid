entity_draw();

flipTimer += DELTA_TIME * spriteSpeed;
if (flipTimer > 1.0){
	flipTimer	 -=  1.0;
	image_xscale *= -1;
}