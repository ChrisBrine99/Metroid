/// @description Editing the Ambient Light
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Scaling the ambient light's size
if (image_speed > 0){
	if (ambLight != noone){
		ambLight.xRad = choose(35, 40, 45);
		ambLight.yRad = ambLight.xRad;
		ambLight.lightCol = choose(c_aqua, c_lime, c_white);
	}
}