// Make sure the power bomb's surface exists before it is drawn to.
if (!surface_exists(pBombSurf)) {pBombSurf = surface_create(surfWidth, surfHeight);}

// Draw the power bomb's explosion to its surface. First, a copy of the application surface is rendered in a
// darkened state. Then, the explosion is placed above it in a similar fashion to how the game's lighting
// system renders itself.
surface_set_target(pBombSurf);

draw_clear(c_black);
draw_surface_ext(application_surface, 0, 0, 1, 1, 0, HEX_GRAY, 1);
gpu_set_blendmode(bm_add);

var _camID = CAMERA.camera.ID;
var _x = x - camera_get_view_x(_camID);
var _y = y - camera_get_view_y(_camID);
var _radius = floor(pBombRadius);
draw_ellipse_color(_x - _radius, _y - _radius, _x + _radius, _y + _radius, HEX_LIGHT_YELLOW, HEX_BLACK, false);

gpu_set_blendmode(bm_normal);
surface_reset_target();

// Finally, draw the resulting surface onto the GUI layer so it can move around indepently of the explosion's
// origin and also utilize the finalized application surface.
draw_surface_ext(pBombSurf, 0, 0, 1, 1, 0, HEX_WHITE, pBombAlpha);