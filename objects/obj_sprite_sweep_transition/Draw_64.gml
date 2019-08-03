/// @description Draw the sprite
// You can write your code in this editor

if (playerSpr != -1){
	draw_sprite_ext(playerSpr, curImg, round(x), round(y), imgXScale, imgYScale, 0, c_white, 1);
}

draw_text_outline(5, 5, "endXPos: " + string(endXPos) + "\nendYPos: " + string(endYPos), c_white, c_gray);