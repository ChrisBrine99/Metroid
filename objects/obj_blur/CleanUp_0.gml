/// @description Cleaning up shader stuff
// You can write your code in this editor

// Free the surface
if (surface_exists(surfBlur)) surface_free(surfBlur);
// Begin automatically drawing the application surface again
application_surface_draw_enable(true);