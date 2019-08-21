/// @description Editing the Ambient Light
// You can write your code in this editor

// Call the parent's step event
event_inherited();

// Scaling the ambient light's size
if (image_speed > 0){
	if (ambLight != noone){
		flashingTime = scr_update_value_delta(flashingTime, -1);
		var fTime = flashingTime;
		with(ambLight){
			if (fTime < 0){
				xRad = choose(35, 40, 45);
				yRad = xRad;
				lightCol = choose(c_aqua, c_lime, c_white);
				other.flashingTime = 1;
			}
		}
	}
}