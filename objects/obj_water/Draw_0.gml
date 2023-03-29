if (!surface_exists(surfWater)){
	var _camera = CAMERA.camera;
	surfWater = surface_create(camera_get_view_width(_camera), camera_get_view_height(_camera));
}

// 
var _camera = -1;
var _camX = 0;
var _camY = 0;
var _camWidth = 0;
var _camHeight = 0;
var _x = 0;
var _y = 0;
with(CAMERA){
	_camera = camera;
	_camX = camera_get_view_x(_camera);
	_camY = camera_get_view_y(_camera);
	_camWidth = camera_get_view_width(_camera);
	_camHeight = camera_get_view_height(_camera);
	_x = -_camX;
	_y = -_camY;
}

// 
surface_set_target(surfWater);
draw_surface(application_surface, 0, 0);

// 
var _deltaTime = DELTA_TIME;
gpu_set_tex_filter(true);
for (var i = 0; i < 2; i++){
	with(liquidLayer[i]){
		x += hspd * _deltaTime;
		y += vspd * _deltaTime;
		if (x < -size || x > size) {x -= (size * sign(hspd));}
		if (y < -size || y > size) {y -= (size * sign(vspd));}
		draw_sprite_tiled_ext(sprite, 0, (-_camX + x), (-_camY + y), scale, scale, c_white, alpha);
	}
}
gpu_set_tex_filter(false);

// 
surface_reset_target();

// 
var _width = (16 * image_xscale);
var _height = (16 * image_yscale);

// 
_x += x;
_y += y;
if (_x < -_width || _y < -_height || _x > _camWidth || _y > _camHeight) {return;}
draw_surface_part(surfWater, _x, _y, _width, _height, x, y);