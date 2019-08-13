/// @description Drawing the lava tiles
// You can write your code in this editor

var tilePosX, tilePosY;
tilePosX = x;
tilePosY = y;
for (var iX = 0; iX < image_xscale; iX++){
	for (var iY = 0; iY < image_yscale; iY++){
		// Only draw the sprite if it is visible by the camera
		if (tilePosX + 16 >= global.camX && tilePosY + 16 >= global.camY && tilePosX <= global.camX + global.camWidth && tilePosY <= global.camY + global.camHeight){
			draw_sprite(spr_lava_visible, imgIndex, tilePosX, tilePosY);
		}
		tilePosY += 16;
	}
	// Reset the Y position
	tilePosY = y;
	tilePosX += 16;
}
