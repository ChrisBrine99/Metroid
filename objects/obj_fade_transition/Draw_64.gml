/// @description Draw the Rectangle
// You can write your code in this editor

if (alpha > 0){
	draw_sprite_ext(spr_generic_rectangle, 0, 0, 0, global.camWidth, global.camHeight, 0, rectCol, alpha);	
}

draw_set_alpha(1);
draw_text_outline(5, 5, "Alpha: " + string(alpha), c_white, c_gray);