/// @description Shaking the screen
// You can write your code in this editor

// Call the parent object's step event
event_inherited();

// Calling the script that shakes the screen
scr_camera_shake(5, 5);

// Scaling the ambient light's size
if (image_speed > 0){
	if (ambLight != noone){
		flashingTime = scr_update_value_delta(flashingTime, -1);
		var fTime = flashingTime;
		with(ambLight){
			if (fTime < 0){
				xRad = choose(80, 85, 90);
				yRad = xRad;
				lightCol = choose(c_fuchsia, c_lime, c_white);
				other.flashingTime = 1;
			}
		}
	}
}