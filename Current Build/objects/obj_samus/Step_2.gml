/// @description The lighting system
// You can write your code in this editor

if (global.energy == 0 && global.eTanks == 0){
	return;	
}

if (instance_exists(obj_lighting)){
	var radius, origin, color;
	if (!global.screwAttack || (!jumpspin && global.screwAttack) || inMorphball){
		color = c_ltgray;
		radius = 40;
	}
	else{
		color = choose(c_yellow, c_lime, c_aqua);
		radius = choose(70, 75, 80, 85);
	}
	origin = y;
	if (crouching && !inMorphball) origin = y + lengthdir_y(6, gravDir);
	else if (inMorphball) origin = y + 12;
	// Draw the light
	scr_draw_light(x, origin, radius, radius, color);
}