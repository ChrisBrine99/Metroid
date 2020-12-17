/// @description Display Collision Boxes for Objects On Screen

if (!showDebugInfo){
	return;
}

with(par_entity){
	draw_rect_outline(bbox_left, bbox_top, 1 + (bbox_right - bbox_left), 1 + (bbox_bottom - bbox_top), c_white, c_gray, 0.5, 1);
}