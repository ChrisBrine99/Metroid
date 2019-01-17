/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_lighting)){
	var radiusX, radiusY, color;
	if (direction == 0 || direction == 180){
		radiusX = round(sprite_width * 1.4);
		radiusY = round(sprite_height * 1.4);
	}
	else if (direction == 90 || direction == 270){
		radiusX = round(sprite_height * 1.4);
		radiusY = round(sprite_width * 1.4);	
	}
	switch(setIndex){
		case 0: // Powerbeam light color
			color = c_orange;
			break;
		case 1: // Icebeam light color
			color = c_aqua;
			break;
		case 2: // Wavebeam light color
			color = c_purple;
			break;
		case 3: // Spazerbeam light color
			color = c_lime;
			break;
		case 4: // Plasmabeam light color
			color = c_red;
			break;
	}
	scr_draw_light(x, y, radiusX, radiusY, color);
}