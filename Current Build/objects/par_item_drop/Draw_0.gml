/// @description Make a flicker effect when the item is about to despawn
// You can write your code in this editor

if (despawnTimer < 120){
	if (image_alpha == 1)
		image_alpha = 0;
	else
		image_alpha = 1;
	image_speed = 2.5;
}

draw_self();