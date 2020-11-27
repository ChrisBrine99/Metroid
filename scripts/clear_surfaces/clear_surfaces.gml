/// @description Frees all surfaces from texture memory. This is useful for resizing surfaces whenever the game's
/// aspect ratio is changed.

function clear_surfaces(){
	if (surface_exists(resultSurface)) {surface_free(resultSurface);}
	if (surface_exists(auxSurfaceA)) {surface_free(auxSurfaceA);}
	if (surface_exists(auxSurfaceB)) {surface_free(auxSurfaceB);}
}