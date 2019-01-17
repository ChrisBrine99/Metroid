/// @description Drawing the lighting system to the screen.
// You can write your code in this editor

if (!surface_exists(global.lighting)){
	global.lighting = surface_create(global.camWidth, global.camHeight);	
}

gpu_set_blendmode(bm_subtract);
draw_surface(global.lighting, global.camX, global.camY);
gpu_set_blendmode(bm_normal);