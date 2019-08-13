/// @description Drawing the door's sprite
// You can write your code in this editor

draw_sprite_ext(sprite_index, floor(imgIndex), x, y, image_xscale, image_yscale, image_angle, c_white, 1);

// Handling animation speeds
var holdTime = (sprite_get_speed(sprite_index) / 60) * global.deltaTime;
imgIndex += imgSpd * holdTime;
if (imgIndex >= sprite_get_number(sprite_index)){
	imgIndex = 0;
	// Destroy the Door, Unlock if Required
	if (!open){
		if (index >= 0) {global.door[index] = true;}
		instance_destroy(self);
	}
} else if (imgIndex <= 0){
	imgIndex = 0;	
}