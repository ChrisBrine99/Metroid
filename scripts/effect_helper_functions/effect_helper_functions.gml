/// @description Contains general helper functions that work in tandem with the shader effects. These include
/// changing the color for the global light source, resetting surfaces, and so on.

/// @description Sets the color, brightness, contrast, and saturation of the lighting inside of whatever room
/// calls this function. MAKE SURE TO ONLY USE THIS IN THE CREATION CODE OF A GIVEN ROOM.
/// @param color[r/g/b]
/// @param brightness
/// @param contrast
/// @param saturation
function set_lighting(_color, _brightness, _contrast, _saturation) {
	with(global.effectID){
		lightColor = _color;
		lightBrightness = _brightness;
		lightContrast = _contrast;
		lightSaturation = _saturation;
	}
}

/// @description Frees all surfaces from texture memory. This is useful for resizing surfaces whenever the game's
/// aspect ratio is changed.
function clear_surfaces(){
	if (surface_exists(resultSurface)) {surface_free(resultSurface);}
	if (surface_exists(auxSurfaceA)) {surface_free(auxSurfaceA);}
	if (surface_exists(auxSurfaceB)) {surface_free(auxSurfaceB);}
}