/// @description Setting the offset of the projectile
// You can write your code in this editor

// Setting the projectile's position
x += offsetX;
y += offsetY;

// Editing the size of the ambient light
if (ambLight != noone){
	if (left || right){ // Moving left or right
		ambLight.xRad = sprite_width * 2;
		ambLight.yRad = sprite_height * 2;
	} else if (up || down){ // Moving up or down
		ambLight.xRad = sprite_height * 2;
		ambLight.yRad = sprite_width * 2;
	}
}

// Make the sprite visible
visible = true;