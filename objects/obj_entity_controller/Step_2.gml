/// @description Move the entity's ambient light
// You can write your code in this editor

if (ambLight != noone){
	with(ambLight){
		// Setting its position relative to the entity's position
		x = other.x + other.xOffset;
		y = other.y + other.yOffset;
	}
}