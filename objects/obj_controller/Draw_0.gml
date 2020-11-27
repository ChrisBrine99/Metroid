/// @description Display Collision Boxes for Objects On Screen

if (!showDebugInfo){
	return;
}

with(par_entity){
	draw_sprite(mask_index, 0, x, y);
}